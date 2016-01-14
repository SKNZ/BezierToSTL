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
            (1.0 - X) ** 2 * BQ.Debut
            + 2.0 * X * (1.0 - X) * BQ.Controle
            + X ** 2 * BQ.Fin; 
    end;
end Courbes.Bezier.Quadratiques;
