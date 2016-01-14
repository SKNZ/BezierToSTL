package body Courbes is
    use Liste_Points;

    function Obtenir_Debut (C : Courbe) return Point2D is
    begin
        return C.Debut;
    end;

    function Obtenir_Fin (C : Courbe) return Point2D is
    begin
        return C.Fin;
    end;

    procedure Interpolation_Lineaire(C : Courbe; Segments : in out Liste; Nombre_Points : Positive) is
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
end Courbes;
