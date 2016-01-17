with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Exceptions; use Ada.Exceptions;

with STL; use STL;
with Parser_Svg; use Parser_Svg;
with Normalisation; use Normalisation;
with Courbes; use Courbes;
with Courbes.Interpolations_Lineaires; use Courbes.Interpolations_Lineaires;
with Vecteurs; use Vecteurs;
with Helper; use Helper;

procedure BezierToSTL is
    Courbes : Liste_Courbes.Liste;
    Segments : Liste_Points.Liste;
    Facettes : Liste_Facettes.Liste;

    -- Nombre de points à utiliser pour la discretisation
    Nombre_Points_Interpolation : constant Positive := 50;

    -- Faut il interpoler les droites
    -- ou laisser cette tâche à l'affichage ?
    -- WARNING: Ne pas activer avec De Casteljau
    -- Sinon risque de trop grand nombre de points
    -- rendant stlviewer inutilisable
    Interpoler_Droites : constant Boolean := false;

    -- Utiliser l'algorithme de De Casteljau
    -- pour interpoler les courbes de Bezier cubiques
    -- => Courbes plus jolies/lisses
    -- => Le nombre de point est ignoré pour les courbes concernées
    -- => car il est déterminé automatiquement
    -- WARNING: Ne pas activer avec Interpoler_Droites 
    -- Sinon risque de trop grand nombre de points
    -- rendant stlviewer inutilisable
    Utiliser_DeCasteljau : constant Boolean := true;

    -- Tolérance utilisée si Utiliser_DeCasteljau
    -- Définit une tolérance pour
    -- savoir quand une courbe peut être
    -- considérée "droite"
    -- Plus petit = tolérance plus strict
    -- => Approximation plus précise
    -- et inversement.
    -- A valeur entre 0.01 et 1.0.
    Tolerance_DeCasteljau : constant Tolerance := 0.1;

    -- Permet de libérer la mémoire allouée pour
    -- toutes les courbes d'une liste
    procedure Liberer_Liste_Courbes is new Liste_Courbes.Parcourir(Liberer_Courbe);

    -- Nombre de facette à générer pendant la rotation
    Nombre_Facettes : constant Positive := 50;
begin
    if Argument_Count /= 2 then
        Put_Line(Standard_Error,
        "usage : " & Command_Name &
        " fichier_entree.svg fichier_sortie.stl");
        Set_Exit_Status(Failure);
        return;
    end if;

    -- On charge la courbe contenu dans le SVG
    Charger_SVG(Argument(1), Courbes);

    -- Approximation des courbes par des segments 
    Interpolation_Lineaire (
        Courbes => Courbes,
        Segments => Segments,
        Nombre_Points => Nombre_Points_Interpolation,
        Interpoler_Droites => Interpoler_Droites,
        Utiliser_DeCasteljau => Utiliser_DeCasteljau,
        Tolerance_DeCasteljau => Tolerance_DeCasteljau);

    -- On normalise la figure
    -- (centrage en x, raccordage extremités)
    Normaliser(Segments);

    -- On convertit en facettes par rotation
    Creation(Segments, Facettes, Nombre_Facettes);

    -- On sauvegarde le modele obtenu
    Sauvegarder(Argument(2), Facettes);

    -- Libère la mémoire allouée pour chaque courbe
    Liberer_Liste_Courbes (Courbes);

    -- Libère la mémoire allouée pour les listes
    Liste_Courbes.Vider(Courbes);
    Liste_Points.Vider(Segments);
    Liste_Facettes.Vider(Facettes);
exception
    when Courbe_Abs =>
        Put_Line (Standard_Error,
        "Le fichier source ne contenait pas de courbe.");
        Set_Exit_Status (Failure);
    when e: Courbe_Illisible =>
        Put_Line (Standard_Error,
        "Le fichier source est mal formé: " & exception_message (e));
        Set_Exit_Status (Failure);
    when e: Erreur_Lecture =>
        Put_Line (Standard_Error,
        "Le fichier source est mal formé: " & exception_message (e));
        Set_Exit_Status (Failure);
end;
