with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics; use Ada.Numerics;
with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;
with Helper; use Helper;

package body STL is
    procedure Creation(
        Segments : in out Liste_Points.Liste ;
        Facettes : out Liste_Facettes.Liste;
        Nombre_Facettes : Positive)
    is
        -- Angle de la rotation en radian
        Angle_Radian : constant Float := (2.0 * PI) / Float(Nombre_Facettes);

        -- Crée un "cercle" de facettes
        procedure Creer_Facette(P_Cour, P_Suiv : in Point2D) is
            -- Calcul du point suivant en effectuant une rotation autour
            -- de l'axe x=0 à partir de P
            function Calculer_Point(P : Point2D; Pas : Integer) return Point3D is
            begin
                return (
                    1 => P(P'First),
                    2 => P(P'Last) * Cos(Float(Pas) * Angle_Radian),
                    3 => P(P'Last) * Sin(Float(Pas) * Angle_Radian));
            end;
        begin
            for Pas in 0 .. Nombre_Facettes loop
                declare
                    F1 : constant Facette := (
                        P1 => Calculer_Point (P_Suiv, Pas),
                        P2 => Calculer_Point (P_Cour, Pas),
                        P3 => Calculer_Point (P_Cour, Pas + 1));

                    F2 : constant Facette := (
                        P1 => Calculer_Point (P_Suiv, Pas + 1),
                        P2 => Calculer_Point (P_Suiv, Pas),
                        P3 => Calculer_Point (P_Cour, Pas + 1));
                begin
                    -- On ajoute une facette dans la liste (i.e. 3 points 3D)
                    Liste_Facettes.Insertion_Queue(Facettes, F1);

                    -- On ajoute la deuxième facette
                    Liste_Facettes.Insertion_Queue(Facettes, F2);
                end;
            end loop;
        end;

        -- Construit l'image 3D
        procedure Construire_STL is new Liste_Points.Parcourir_Par_Couples(Creer_Facette);

    begin
        Debug("Projection avec angle: " & Float'Image(Angle_Radian));
        Debug("Nombre de facettes: " & Integer'Image(Nombre_Facettes));

        -- Mise en oeuvre :
        -- On prend n dans 1..Taille(Segments) et on considère Pn un Point2D
        -- Chaque pas k (k dans (0,M-1)) de l'angle de rotation alpha génère un couple de Facettes (en 3D)
        -- Informellement, on a les facettes :
        -- (Pn + k*alpha, Pn-1 + k*alpha, Pn-1 + (k+1)*alpha)
        -- et
        -- (Pn + k*alpha, Pn-1 + (k+1)*alpha, Pn + (k+1)*alpha)

        -- Ensuite on construit les facettes
        Construire_STL(Segments);

        Debug("Fin projection");
        Debug;
    end;

    procedure Sauvegarder(
        Nom_Fichier : String ;
        Facettes : Liste_Facettes.Liste)
    is
        Fichier : File_Type;

        -- Ecrit le code STL pour une facette
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

        procedure Affiche_Code_STL is new Liste_Facettes.Parcourir(Display_Facette_STL);
    begin
        Debug("Sauvegarde vers fichier: " & Nom_Fichier);
        begin
            Open (Fichier, Out_File, Nom_Fichier);
            Debug("Fichier existe => tronqué");
        exception
            when Name_Error => 
                -- Si le fichier n'existe pas
                Create (Fichier, Out_File, Nom_Fichier);
                Debug("Fichier crée");
        end;

        Put(Fichier, "solid " & Nom_Fichier);
        New_Line (Fichier);
        Affiche_Code_STL(Facettes);
        Put(Fichier, "endsolid " & Nom_Fichier);

        Close(Fichier);

        Debug("Fin écriture");
    end;
end;
