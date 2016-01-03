with Ada.Text_IO;
use Ada.Text_IO;

package body STL is

    procedure Creation(Segments : in out Liste_Points.Liste ;
        Facettes : out Liste_Facettes.Liste) is

        -- Crée un "cercle" de facettes
        procedure Creer_Facette(P_Cour, P_Suiv : in Point2D) is
        begin
            for Pas in 0..M loop
                -- On ajoute une facette dans la liste
                -- (i.e. 3 points 3D)
                -- TODO pas très swag tout ça -> faire quelque chose !
                Liste_Facettes.Insertion_Queue(Facettes,
                                               ((1 => P_Suiv(P_Suiv'First) * Cos(Float(Pas) * Angle_Radian),
                                                2 => P_Suiv(P_Suiv'Last),
                                                3 => P_Suiv(P_Suiv'First) * Sin(Float(Pas) * Angle_Radian)),
                                               (1 => P_Cour(P_Cour'First) * Cos(Float(Pas) * Angle_Radian),
                                                2 => P_Cour(P_Cour'Last),
                                                3 => P_Cour(P_Cour'First) * Sin(Float(Pas) * Angle_Radian)),
                                               (1 => P_Cour(P_Cour'First) * Cos(Float(Pas+1) * Angle_Radian),
                                                2 => P_Cour(P_Cour'Last),
                                                3 => P_Cour(P_Cour'First) * Sin(Float(Pas+1) * Angle_Radian))));
                -- On ajoute la deuxième facette
                Liste_Facettes.Insertion_Queue(Facettes,
                                               ((1 => P_Suiv(P_Suiv'First) * Cos(Float(Pas) * Angle_Radian),
                                                2 => P_Suiv(P_Suiv'Last),
                                                3 => P_Suiv(P_Suiv'First) * Sin(Float(Pas) * Angle_Radian)),
                                               (1 => P_Cour(P_Cour'First) * Cos(Float(Pas+1) * Angle_Radian),
                                                2 => P_Cour(P_Cour'Last),
                                                3 => P_Cour(P_Cour'First) * Sin(Float(Pas+1) * Angle_Radian)),
                                               (1 => P_Suiv(P_Suiv'First) * Cos(Float(Pas+1) * Angle_Radian),
                                                2 => P_Suiv(P_Suiv'Last),
                                                3 => P_Suiv(P_Suiv'First) * Sin(Float(Pas+1) * Angle_Radian))));
            end loop;
        end;

        -- Construit l'image 3D
        procedure Construire_STL is new Liste_Points.Parcourir_Par_Couples(Traiter => Creer_Facette);

    begin
        -- IDEE :
        -- On prend n dans 1..Taille(Segments) et on considère Pn un Point2D
        -- Chaque pas k (k dans (0,M-1)) de l'angle de rotation alpha génère un couple de Facettes (en 3D)
        -- (Pn + k*alpha, Pn-1 + k*alpha, Pn-1 + (k+1)*alpha)
        -- et
        -- (Pn + k*alpha, Pn-1 + (k+1)*alpha, Pn + (k+1)*alpha)
        
        Construire_STL(Segments);
    end;


    procedure Sauvegarder(
        Nom_Fichier : String ;
        Facettes : Liste_Facettes.Liste)
    is
        Fichier : File_Type;

        -- Affiche le code STL pour une facette
        procedure Display_Facette_STL(Triplet : in out Facette) is
        begin
            Put(Fichier, "facet");
            New_Line (Fichier);
            Put(Fichier, "outer loop");
            New_Line (Fichier);
            Put(Fichier, "vertex " & Float'Image(Triplet.P1(Triplet.P1'First)) &
            " " & Float'Image(Triplet.P1(Triplet.P1'First+1)) &
            " " & Float'Image(Triplet.P1(Triplet.P1'First+2)));
            New_Line (Fichier);
            Put(Fichier, "vertex " & Float'Image(Triplet.P2(Triplet.P2'First)) &
            " " & Float'Image(Triplet.P2(Triplet.P2'First+1)) &
            " " & Float'Image(Triplet.P2(Triplet.P2'First+2)));
            New_Line (Fichier);
            Put(Fichier, "vertex " & Float'Image(Triplet.P3(Triplet.P3'First)) &
            " " & Float'Image(Triplet.P3(Triplet.P3'First+1)) &
            " " & Float'Image(Triplet.P3(Triplet.P3'First+2)));
            New_Line (Fichier);
            Put(Fichier, "endloop");
            New_Line (Fichier);
            Put(Fichier, "endfacet");
            New_Line (Fichier);
        end;

        procedure Affiche_Code_STL is new Liste_Facettes.Parcourir(Traiter => Display_Facette_STL);
    begin
        begin
            Open (Fichier, Out_File, Nom_Fichier);
        exception
            when Name_Error => 
                -- Si le fichier n'existe pas
                Create (Fichier, Out_File, Nom_Fichier);
        end;
        Put(Fichier, "solid " & Nom_Fichier);
        New_Line (Fichier);
        Affiche_Code_STL(Facettes);
        Put(Fichier, "endsolid " & Nom_Fichier);
    end;
end;
