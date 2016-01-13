with ada.text_io; use ada.text_io;

package body Courbes.Bezier.Cubiques is
    function Ctor_Bezier_Cubique (Debut, Fin, C1, C2 : Point2D) return access Bezier_Cubique is
        Controles : Bezier_Cubique_Controles :=
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
        Put_Line("BC");
        return
            (1.0 - X) * (1.0 - X) * (1.0 - X) * BC.Debut 
            + 3.0 * X * (1.0 - X) * (1.0 - X) * BC.Controles (1)
            + 3.0 * X * X * (1.0 - X) * BC.Controles (2) 
            + X * X * X * BC.Fin; 
    end;
end Courbes.Bezier.Cubiques;
