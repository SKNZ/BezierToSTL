with Ada.Command_Line; use Ada.Command_Line;
with STL; use STL;
with Parser_Svg; use Parser_Svg;
with Ada.Text_IO; use Ada.Text_IO;
with Math; use Math;
with Normalisation; use Normalisation;
with Ada.Exceptions; use Ada.Exceptions;
with Courbes; use Courbes;
with Courbes.Droites; use Courbes.Droites;
with Vecteurs; use Vecteurs;

procedure Main is
    Segments : Liste_Points.Liste;
    Facettes : Liste_Facettes.Liste;
    d : Courbe'Class := Ctor_Droite((others => 1.0), (others => 9.0));
begin
    Put_Line(To_String (d.Obtenir_Point (1.0)));
    return;
    if Argument_Count /= 2 then
        Put_Line(Standard_Error,
        "usage : " & Command_Name &
        " fichier_entree.svg fichier_sortie.stl");
        Set_Exit_Status(Failure);
        return;
    end if;

    --on charge la courbe de bezier et la convertit en segments
    Chargement_Bezier(Argument(1), Segments);

    -- On normalise la figure
    Normaliser(Segments);

    --on convertit en facettes par rotation
    Creation(Segments, Facettes);

    --on sauvegarde le modele obtenu
    Sauvegarder(Argument(2), Facettes);

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
