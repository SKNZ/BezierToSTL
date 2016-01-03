with Ada.Command_Line; use Ada.Command_Line;
with STL; use STL;
with Parser_Svg; use Parser_Svg;
with Ada.Text_IO; use Ada.Text_IO;
with Math; use Math;
with Ada.Exceptions; use Ada.Exceptions;

procedure Main is
    Segments : Liste_Points.Liste;
    Facettes : Liste_Facettes.Liste;

    -- Quelques variables de test
    P1, C1, C2, P2 : Point2D;
    Points : Liste_Points.Liste;
    Points2 : Liste_Points.Liste;
begin
    if Argument_Count /= 2 then
        Put_Line(Standard_Error,
        "usage : " & Command_Name &
        " fichier_entree.svg fichier_sortie.stl");
        Set_Exit_Status(Failure);
        return;
    end if;

    --on charge la courbe de bezier et la convertit en segments
    Chargement_Bezier(Argument(1), Segments);
    --on convertit en facettes par rotation
    Creation(Segments, Facettes);
    --on sauvegarde le modele obtenu
    Sauvegarder(Argument(2), Facettes);


    -- TESTS
    -- P1 := (100.0, 100.0);
    -- C1 := (130.0, 60.0);
    -- C2 := (130.0, 60.0);
    -- P2 := (200.0, 100.0);

    -- Bezier(P1, C1, C2, P2, 15, Points);
    -- Bezier(P1, C1, P2, 15, Points2);
    -- Liste_Points.Fusion(Points, Points2);    
    -- Creation(Points, Facettes);
    -- Sauvegarder("fichier.stl", Facettes); 

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
