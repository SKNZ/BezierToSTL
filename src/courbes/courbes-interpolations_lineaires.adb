with Ada.Text_IO; use Ada.Text_IO;
package body Courbes.Interpolations_Lineaires is
    procedure Interpolation_Lineaire(C : Courbe_Ptr; Segments : in out Liste; Nombre_Points : Positive) is
        package Interpolateur is new Visiteur_Interpolateur (Segments, Nombre_Points);        
        Visitateur : Interpolateur.Interpolateur_Lineaire;
    begin
        C.Visiter (Visitateur);
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

        -- Cas particulier : le singleton
        overriding procedure Visiter(Self : Interpolateur_Lineaire; S : Singleton) is
        begin
            Insertion_Queue(Segments, S.Obtenir_Debut);
        end;
    end Visiteur_Interpolateur;
end Courbes.Interpolations_Lineaires;
