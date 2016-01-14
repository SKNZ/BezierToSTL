with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Exceptions; use Ada.Exceptions;

with STL; use STL;
with Parser_Svg; use Parser_Svg;
with Normalisation; use Normalisation;
with Courbes; use Courbes;
with Vecteurs; use Vecteurs;
with Helper; use Helper;

procedure BezierToSTL is
    Courbes : Liste_Courbes.Liste;
    Segments : Liste_Points.Liste;
    Facettes : Liste_Facettes.Liste;

    -- Nombre de points à utiliser pour la discretisation
    Nombre_Points_Discrets : constant Positive := 50;
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

    declare
        -- Instanciation générique 
        -- Helper dans helper
        procedure Interpolation_Lineaire_Courbe is new Interpolation_Lineaire_Gen(Segments, Nombre_Points_Discrets);
       
        -- Fonction de traitement pour toutes les courbes
        procedure Interpolation_Lineaire_Courbes is new Liste_Courbes.Parcourir(Interpolation_Lineaire_Courbe);
    begin
        -- On discrète les courbes
        Interpolation_Lineaire_Courbes (Courbes);
    end;

    -- On normalise la figure
    -- (centrage en x, raccordage extremités)
    Normaliser(Segments);

    -- On convertit en facettes par rotation
    Creation(Segments, Facettes);

    -- On sauvegarde le modele obtenu
    Sauvegarder(Argument(2), Facettes);

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
end;
