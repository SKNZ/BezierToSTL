package body Courbes.Interpolations_Lineaires is
    procedure Interpolation_Lineaire(C : Courbe; Segments : in out Liste_Points.Liste; Nombre_Points : Positive) is
        Interpolateur : Interpolateur_Lineaire := (Segments => null, Nombre_Points => Nombre_Points);
    begin
        C.Visiter (Interpolateur);
    end;

    -- Interpolation linéaire d'une courbe en N points
    overriding procedure Visiter(Self : Interpolateur_Lineaire; C : Courbe) is
        -- Pas de l'interpolation
        Pas : constant Float := 1.0 / float(Self.Nombre_Points);

        -- On récupère le class-wide
        CC : constant Courbe'Class := C;
    begin
        for I in 0 .. Self.Nombre_Points loop
            declare
                -- Et la bim, redispatching !
                P : constant Point2D := CC.Obtenir_Point(float(I) * Pas);
            begin
                -- On ajoute le point calculé à la fin
                Insertion_Queue(Self.Segments.all, P);
            end;
        end loop;
    end;

    -- Cas particulier : le singleton
    overriding procedure Visiter(Self : Interpolateur_Lineaire; S : Singleton) is
    begin
        Insertion_Queue(Self.Segments.all, S.Obtenir_Debut);
    end;
end Courbes.Interpolations_Lineaires;
