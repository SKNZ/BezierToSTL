package body Courbes.Interpolations_Lineaires is
    procedure Interpolation_Lineaire(
        C : Courbe_Ptr;
        Segments : in out Liste;
        Nombre_Points : Positive;
        Interpoler_Droites : Boolean)
    is
        -- Instanciation du package de l'interpolateur avec les bons paramètres
        package Interpolateur is new Visiteur_Interpolateur (Segments, Nombre_Points);        

        -- Instanciation du visiteur même
        V : Interpolateur.Interpolateur_Lineaire;
    begin
        C.Visiter (V);
    end;

    -- Param génériques: Segments (Liste_Points), Nombre_Points (Positive)
    package body Visiteur_Interpolateur is
        -- Interpolation linéaire d'une courbe en N points
        overriding procedure Visiter(Self : Interpolateur_Lineaire; C : Courbe) is
            -- Pas de l'interpolation
            Pas : constant Float := 1.0 / float(Nombre_Points);

            -- On récupère le class-wide
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
                -- On l'interpole comme n'importe quelle autre courbe
                Self.Visiter(Courbe(D));
                return;
            else
                -- On n'enregistre que les deux premiers points
                Insertion_Queue(Segments, S.Obtenir_Debut);
                Insertion_Queue(Segments, S.Obtenir_Fin);
            end if;
        end;

        -- Cas particulier : le singleton
        overriding procedure Visiter(Self : Interpolateur_Lineaire; S : Singleton) is
        begin
            Insertion_Queue(Segments, S.Obtenir_Debut);
        end;
    end Visiteur_Interpolateur;
end Courbes.Interpolations_Lineaires;
