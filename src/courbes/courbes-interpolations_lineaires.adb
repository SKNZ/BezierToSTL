with Ada.Text_IO; use Ada.Text_IO;

package body Courbes.Interpolations_Lineaires is
    -- Interpole toutes les courbes d'une liste
    procedure Interpolation_Lineaire(
        Courbes : Liste_Courbes.Liste;
        Segments : in out Liste;
        Nombre_Points : Positive;
        Interpoler_Droites : Boolean := False;
        Utiliser_DeCasteljau : Boolean := False;
        Tolerance_DeCasteljau : Tolerance := 0.5)
    is
        -- Instanciation du package de l'interpolateur avec les bons paramètres
        package Interpolateur is new Visiteur_Interpolateur
            (Segments,
            Nombre_Points,
            Interpoler_Droites,
            Utiliser_DeCasteljau,
            Tolerance_DeCasteljau);        

        -- Instanciation du visiteur même
        V : Interpolateur.Interpolateur_Lineaire;

        procedure Interpoler_Helper (C : in out Courbe_Ptr) is
        begin
            -- On fait visiter la courbe par l'interpolateur
            C.Accepter (V);
        end;

        -- Générique permettant d'appliquer le helper à la liste
        procedure Traiter_Liste is new Liste_Courbes.Parcourir(Traiter => Interpoler_Helper);
    begin
        -- Appel de l'helper sur chaque courbe
        Traiter_Liste(Courbes);
    end;

    procedure Interpolation_Lineaire(
        C : Courbe_Ptr;
        Segments : in out Liste;
        Nombre_Points : Positive;
        Interpoler_Droites : Boolean := False;
        Utiliser_DeCasteljau : Boolean := False;
        Tolerance_DeCasteljau : Tolerance := 0.5)
    is
        -- Instanciation du package de l'interpolateur avec les bons paramètres
        package Interpolateur is new Visiteur_Interpolateur
            (Segments,
            Nombre_Points,
            Interpoler_Droites,
            Utiliser_DeCasteljau,
            Tolerance_DeCasteljau);

        -- Instanciation du visiteur même
        V : Interpolateur.Interpolateur_Lineaire;
    begin
        -- On fait visiter la courbe par le visiteur
        C.Accepter (V);
    end;

    -- Param génériques: Segments (Liste_Points), Nombre_Points (Positive)
    package body Visiteur_Interpolateur is
        -- Interpolation linéaire d'une courbe en N points
        overriding procedure Visiter(Self : Interpolateur_Lineaire; C : Courbe) is
            -- Pas de l'interpolation
            Pas : constant Float := 1.0 / float(Nombre_Points);

            -- On récupère le class-wide
            -- pour le redispatching
            CC : constant Courbe'Class := C;
        begin
            for I in 0 .. Nombre_Points loop
                declare
                    -- Et la bim, redispatching !
                    P : constant Point2D := CC.Obtenir_Point(float(I) * Pas);
                begin
                    -- On ajoute le point calculé à la fin
                    Insertion_Queue(Segments, P);
                end;
            end loop;
        end;

        -- Cas particulier : la droite
        -- La droite n'a pas besoin d'être interpolée ici
        -- Les logiciels d'affichage sont capables de les rendre sans interpoler
        overriding procedure Visiter(Self : Interpolateur_Lineaire; D : Droite) is
        begin
            if Interpoler_Droites then
                declare
                    -- Redispatch
                    CSelf : constant Interpolateur_Lineaire'Class := Self;
                begin
                    -- On l'interpole comme n'importe quelle autre courbe
                    CSelf.Visiter(Courbe(D));
                    return;
                end;
            else
                -- On n'enregistre que les deux points
                -- de début et de fin
                Insertion_Queue(Segments, D.Obtenir_Debut);
                Insertion_Queue(Segments, D.Obtenir_Fin);
            end if;
        end;

        -- Cas particulier : bezier cubique
        -- Uniquement particulier si on utilise
        -- l'algo de De Casteljau
        -- RQ: La version De Casteljau est issue
        -- d'un papier de recherche de Kaspar FISCHER
        -- nommé Piecewise Linear Approximation of Bezier Curves
        -- Le lien est dispo dans le README
        -- Ceci en est juste une implémentation
        overriding procedure Visiter(Self : Interpolateur_Lineaire; BC : Bezier_Cubique) is
        begin
            if not Utiliser_DeCasteljau then
                declare
                    -- Redispatch
                    CSelf : constant Interpolateur_Lineaire'Class := Self;
                begin
                    -- On l'interpole comme n'importe quelle autre courbe
                    CSelf.Visiter(Courbe(BC));
                    return;
                end;
            end if;

            -- Le principe de la version de De Casteljau est:
            -- On a une courbe de bezier quadratique.
            -- Est elle "suffisamment plate" ?
            -- Oui -> interpolation comme une droite
            -- Sinon:
            --  Division en deux courbes de Bezier cubiques
            --  Dont la "somme" équivaut la première
            --  On recommence l'algo sur ces deux courbes
            
            -- Test "plate" 
            declare
                U : Point2D :=
                    (3.0 * BC.Obtenir_Controle1
                    - 2.0 * BC.Obtenir_Debut
                    - BC.Obtenir_Fin) ** 2;

                V : constant Point2D :=
                    (3.0 * BC.Obtenir_Controle2
                    - 2.0 * BC.Obtenir_Fin
                    - BC.Obtenir_Debut) ** 2;
            begin
                if U(U'First) < V(V'First) then
                    U(U'First) := V(V'First);
                end if;

                if U(U'Last) < V(V'Last) then
                    U(U'Last) := V(V'Last);
                end if;

                -- Si la courbe est dans les côtes
                if U(U'First) + U(U'Last) <= 16.0 * (Tolerance_DeCasteljau ** 2) then
                    declare
                        -- Redispatch
                        CSelf : constant Interpolateur_Lineaire'Class := Self;
                    begin
                        -- On l'interpole comme une droite
                        CSelf.Visiter ( Ctor_Droite (BC.Obtenir_Debut, BC.Obtenir_Fin));
                        return;
                    end;
                end if;
            end;
            
            declare
                -- On divise notre courbe de Bezier
                -- en deux courbes de Bezier plus simples
                -- Une dite "gauche" et l'autre "droite"
                Milieu_Controles : constant Point2D := (BC.Obtenir_Controle1 + BC.Obtenir_Controle2) / 2.0;
                
                -- Gauche
                Gauche_Debut : constant Point2D := BC.Obtenir_Debut;
                Gauche_C1 : constant Point2D := (BC.Obtenir_Debut + BC.Obtenir_Controle1) / 2.0;
                Gauche_C2 : constant Point2D := (Gauche_C1 + Milieu_Controles) / 2.0;

                -- Droite
                Droite_Fin : constant Point2D := BC.Obtenir_Fin; 
                Droite_C2 : constant Point2D := (BC.Obtenir_Fin + BC.Obtenir_Controle2) / 2.0;
                Droite_C1 : constant Point2D := (Droite_C2 + Milieu_Controles) / 2.0;

                -- Gauche Debut & Droite Fin
                Gauche_Fin, Droite_Debut : constant Point2D := (Droite_C1 + Gauche_C2) / 2.0;

                Gauche : constant Bezier_Cubique := Ctor_Bezier_Cubique
                    (Gauche_Debut,
                    Gauche_Fin,
                    Gauche_C1,
                    Gauche_C2);

                Droite : constant Bezier_Cubique := Ctor_Bezier_Cubique
                    (Droite_Debut,
                    Droite_Fin,
                    Droite_C1,
                    Droite_C2);
            begin
                declare
                    -- Redispatch
                    CSelf : constant Interpolateur_Lineaire'Class := Self;
                begin
                    -- Algorithme récursif sur la portion gauche
                    CSelf.Visiter(Gauche);

                    -- Algorithme récursif sur la portion droite
                    CSelf.Visiter(Droite);
                    return;
                end;
            end;
        end;

        -- Cas particulier : le singleton
        overriding procedure Visiter(Self : Interpolateur_Lineaire; S : Singleton) is
        begin
            -- Le singleton étant un point unique
            -- On ajoute juste le point à la liste
            Insertion_Queue(Segments, S.Obtenir_Debut);
        end;
    end Visiteur_Interpolateur;
end Courbes.Interpolations_Lineaires;
