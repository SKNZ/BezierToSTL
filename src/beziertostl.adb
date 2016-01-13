with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Exceptions; use Ada.Exceptions;

with STL; use STL;
with Parser_Svg; use Parser_Svg;
with Normalisation; use Normalisation;
with Courbes; use Courbes;
with Courbes.Droites;
with Vecteurs; use Vecteurs;
with Listes_Courbes; use Listes_Courbes;

procedure BezierToSTL is
    Courbes : Liste_Courbes.Liste;
    Segments : Liste_Points.Liste;
    Facettes : Liste_Facettes.Liste;

    -- Nombre de points à utiliser pour la discretisation
    Nombre_Points_Discrets : constant Positive := 50;

    -- d : access Courbe'Class := Droites.Ctor_Droite((others => 1.0), (others => 9.0));

    -- Instanciation générique, helper dans pckg Courbes
    procedure Discretiser_Courbe is new Discretiser_Gen(Segments, Nombre_Points_Discrets);
   
    -- Fonction de traitement pour toutes les courbes
    procedure Discretiser_Courbes is new Liste_Courbes.Parcourir(Discretiser_Courbe);
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

    -- On discrète les courbes
    Discretiser_Courbes (Courbes);

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
