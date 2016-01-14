package body Courbes.Bezier.Cubiques is
    function Ctor_Bezier_Cubique (Debut, Fin, C1, C2 : Point2D) return access Bezier_Cubique is
        Controles : constant Bezier_Cubique_Controles :=
            (1 => C1,
            2 => C2);
    begin
        return 
            new Bezier_Cubique'(
                Debut => Debut,
                Fin => Fin,
                Controles => Controles);
    end;

    function Obtenir_Point(BC : Bezier_Cubique; X : Float) return Point2D is
    begin 
        return
            (1.0 - X) ** 3 * BC.Debut 
            + 3.0 * X * (1.0 - X) ** 2 * BC.Controles (1)
            + 3.0 * X ** 2 * (1.0 - X) * BC.Controles (2) 
            + X ** 3 * BC.Fin; 
    end;
end Courbes.Bezier.Cubiques;
