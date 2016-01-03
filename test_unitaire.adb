with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Math; use Math;
with STL; use STL;

procedure test_unitaire is
    procedure Sauve_SVG(Segments : Liste_Points.Liste) is
        Fichier : File_Type;
        Nom_Fichier : String := "test_unitaire.svg";

        -- Affiche du code svg pour un point
        procedure Display_Point(P : in out Point2D) is
        begin
            Put(Fichier, Float'Image(P(P'First)));
            Put(Fichier, ",");
            Put(Fichier, Float'Image(P(P'Last)));
            Put(Fichier, " ");
        end;

        -- Affiche du code svg pour tout les points
        procedure Display_SVG is new Liste_Points.Parcourir(Traiter => Display_Point);
    begin
        begin
            Open (Fichier, Out_File, Nom_Fichier);
        exception
            when Name_Error => 
                -- Si le fichier n'existe pas
                Create (Fichier, Out_File, Nom_Fichier);
        end;
        Put(Fichier, "<svg>");
        New_Line(Fichier);
        Put(Fichier, "<path d=""M 0 0 L ");
        Display_SVG(Segments);
        Put(Fichier, " Z"" />");
        Put(Fichier, "</svg>");
    end;

    procedure test_cercle is
        Segments : Liste_Points.Liste;
        Facettes : Liste_Facettes.Liste;
    begin
        Liste_Points.Insertion_Queue(Segments, (1.0,0.0));
        Liste_Points.Insertion_Queue(Segments, (1.0,1.0));
        --on convertit en facettes par rotation
        Creation(Segments, Facettes);
        --on sauvegarde le modele obtenu
        Sauvegarder(Argument(2), Facettes);
    end;

    procedure Chapiteau is
        Segments : Liste_Points.Liste;
        Facettes : Liste_Facettes.Liste;
    begin
        Liste_Points.Insertion_Queue(Segments, (1.0,0.0));
        Liste_Points.Insertion_Queue(Segments, (1.0,1.0));
        Liste_Points.Insertion_Queue(Segments, (0.0,2.0));
        --on convertit en facettes par rotation
        Creation(Segments, Facettes);
        --on sauvegarde le modele obtenu
        Sauvegarder(Argument(2), Facettes);
    end;

    procedure Test_Bezier_Cub is
        Segments : Liste_Points.Liste;
        Facettes : Liste_Facettes.Liste;
    begin
        Bezier((0.0, 0.0),
               (200.0, 180.0),
               (200.0, 200.0),
               (0.0, 200.0),
               Nombre_Points, Segments);

        --on convertit en facettes par rotation
        Creation(Segments, Facettes);
        --on sauvegarde le modele obtenu
        Sauvegarder(Argument(2), Facettes);

        -- Sauvegarde en svg pour debug
        Sauve_SVG(Segments);
    end;

    procedure Test_Bezier_Quad is
        Segments : Liste_Points.Liste;
        Facettes : Liste_Facettes.Liste;
    begin
        Bezier((0.0, 0.0),
               (200.0, 100.0),
               (0.0, 200.0),
               Nombre_Points, Segments);

        --on convertit en facettes par rotation
        Creation(Segments, Facettes);
        --on sauvegarde le modele obtenu
        Sauvegarder(Argument(2), Facettes);

        -- Sauvegarde en svg pour debug
        Sauve_SVG(Segments);
    end;

    procedure Test_Fusion is
        Segments : Liste_Points.Liste;
        Segments_2 : Liste_Points.Liste;
        Facettes : Liste_Facettes.Liste;
    begin
        Bezier((0.0, 0.0),
               (200.0, 100.0),
               (100.0, 200.0),
               Nombre_Points, Segments);

        Bezier((100.0, 200.0),
               (200.0, 380.0),
               (200.0, 400.0),
               (0.0, 400.0),
               Nombre_Points, Segments_2);

        Liste_Points.Fusion(Segments, Segments_2);

        --on convertit en facettes par rotation
        Creation(Segments, Facettes);
        --on sauvegarde le modele obtenu
        Sauvegarder(Argument(2), Facettes);

        -- Sauvegarde en svg pour debug
        Sauve_SVG(Segments);
    end;
begin
    Test_Fusion;
end;
