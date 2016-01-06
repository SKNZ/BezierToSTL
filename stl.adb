with Ada.Text_IO;
use Ada.Text_IO;

package body STL is
    procedure Creation(Segments : in out Liste_Points.Liste ;
        Facettes : out Liste_Facettes.Liste) is

        -- Abscisses et ordonnées minimales nécessaires
        -- pour le pré-traitement
        X_Min, Y_Min : Float := 0.0;

        procedure Pre_Traitement(Segments : in out Liste_Points.Liste) is
            Point_Tete : Point2D := Liste_Points.Tete(Segments);
            Point_Queue : Point2D := Liste_Points.Queue(Segments);

            -- Met à jour les minima X_Min et Y_Min
            procedure Comparer_Min(P : in out Point2D) is
            begin
                -- On compare X_Min et l'abscisse du point P
                if P(P'First) < X_Min then
                    X_Min := P(P'First);
                end if;

                -- On compare Y_Min et l'ordonnée du point P
                if P(P'Last) < Y_Min then
                    Y_Min := P(P'Last);
                end if;
            end;

            procedure Chercher_Min is new Liste_Points.Parcourir(Traiter => Comparer_Min);

        begin
            -- On instancie les minima
            X_Min := Point_Tete(Point_Tete'First);
            Y_Min := Point_Tete(Point_Tete'Last);

            -- On calcule les minima
            Chercher_Min(Segments);

            -- TODO Debug
            -- Enfin on raccorde pour éviter les "trous"
            -- Si la coord. Y de début de liste n'est pas sur Y_Min, on
            -- rajoute une coord. au début
            Put_Line("WAIT FOR IT :");
            Put_Line("Y_Min : " & Float'Image(Y_Min));
            Put_Line("Point_Tete(Y) : " & Float'Image(Point_Tete(Point_Tete'Last)));
            Put_Line("Point_Queue(Y) : " & Float'Image(Point_Queue(Point_Queue'Last)));
            --if Point_Tete(Point_Tete'Last) >= Y_Min then
            --    Put_Line("YOYOYOYOYOYOYOYOYOYOYO");
            --    Liste_Points.Insertion_Tete(Segments, (0.0, Point_Tete(Point_Tete'Last) - Y_Min));
            --end if;

            -- Si la coord. Y de fin de liste n'est pas sur X_Min, on
            -- rajoute une coord. à la fin
            if Point_Queue(Point_Queue'First) >= X_Min then
                Liste_Points.Insertion_Queue(Segments, (Point_Tete(Point_Tete'First) - X_Min, 0.0));
            end if;
        end;

        -- Crée un "cercle" de facettes
        procedure Creer_Facette(P_Cour, P_Suiv : in Point2D) is
            function Calculer_Point(P : Point2D; Pas : Integer) return Point3D is
            begin
                return
                    (
                        1 => (P(P'First) - X_Min),
                        2 => (P(P'Last) - Y_Min) * Cos(Float(Pas) * Angle_Radian),
                        3 => (P(P'Last) - Y_Min) * Sin(Float(Pas) * Angle_Radian)
                        );
            end;
        begin
            --Put_Line("PC" & To_String(P_Cour));
            --Put_Line("PS" & To_String(P_Suiv));
            --Put_Line("------------------------");

            --Liste_Facettes.Insertion_Queue(Facettes,
            --(
            --    (Calculer_Point (P_Suiv, 0)),
            --    (Calculer_Point (P_Cour, 0)),
            --    (Calculer_Point (P_Cour, 1))
            --    ));

            --Liste_Facettes.Insertion_Queue(Facettes,
            --(
            --    (Calculer_Point (P_Suiv, 1)),
            --    (Calculer_Point (P_Suiv, 0)),
            --    (Calculer_Point (P_Cour, 1))
            --    ));

            for Pas in 0..M loop
                -- On ajoute une facette dans la liste (i.e. 3 points 3D)
                -- On en profite pour décaler tout les points d'un cran
                -- (de X_Min et de Y_Min)
                Liste_Facettes.Insertion_Queue(Facettes,
                (
                    (Calculer_Point (P_Suiv, Pas)),
                    (Calculer_Point (P_Cour, Pas)),
                    (Calculer_Point (P_Cour, Pas + 1))
                    ));

               -- -- DEBUG
               -- if Pas = 0 then
               --     Put_Line("F1_Calculer_Point (P_Suiv, Pas)" & To_String_3D(Calculer_Point (P_Suiv, Pas)));
               --     Put_Line("F1_Calculer_Point (P_Cour, Pas)" & To_String_3D(Calculer_Point (P_Cour, Pas)));
               --     Put_Line("F1_Calculer_Point (P_Cour, Pas + 1)" & To_String_3D(Calculer_Point (P_Cour, Pas + 1)));
               -- end if;

                -- On ajoute la deuxième facette
                Liste_Facettes.Insertion_Queue(Facettes,
                (
                    (Calculer_Point (P_Suiv, Pas + 1)),
                    (Calculer_Point (P_Suiv, Pas)),
                    (Calculer_Point (P_Cour, Pas + 1))
                    ));
            end loop;
        end;

        -- Construit l'image 3D
        procedure Construire_STL is new Liste_Points.Parcourir_Par_Couples(Traiter => Creer_Facette);

    begin
        Put_Line ("Construction du STL");
        -- IDEE :
        -- On prend n dans 1..Taille(Segments) et on considère Pn un Point2D
        -- Chaque pas k (k dans (0,M-1)) de l'angle de rotation alpha génère un couple de Facettes (en 3D)
        -- (Pn + k*alpha, Pn-1 + k*alpha, Pn-1 + (k+1)*alpha)
        -- et
        -- (Pn + k*alpha, Pn-1 + (k+1)*alpha, Pn + (k+1)*alpha)

        -- On procède au pré-traitement tout d'abord
        Pre_Traitement(Segments);

        -- Ensuite on construit les facettes
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
        Put_Line ("Écriture du STL " & Nom_Fichier);
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
