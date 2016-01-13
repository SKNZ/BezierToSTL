package body Courbes.Bezier.Quadratiques is
    function Ctor_Bezier_Quadratique (Debut, Fin, C : Point2D) return access Bezier_Quadratique is
    begin
        return 
            new Bezier_Quadratique'(
                Debut => Debut,
                Fin => Fin,
                Controle => C);
    end;

    function Obtenir_Point(BQ : Bezier_Quadratique; X : Float) return Point2D is
    begin 
        return
            (1.0 - X) * (1.0 - X) * BQ.Debut
            + 2.0 * X * (1.0 - X) * BQ.Controle
            + X * X * BQ.Fin; 
    end;

    procedure Discretiser(BQ : Bezier_Quadratique; Segments : in out Liste_Points.Liste; Nombre_Points : Positive) is
    begin
        for I in 0 .. Nombre_Points loop
            Insertion_Queue(Segments, BQ.Obtenir_Point(float(I) / float(Nombre_Points)));
        end loop;
    end;
end Courbes.Bezier.Quadratiques;
