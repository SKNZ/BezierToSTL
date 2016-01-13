with ada.text_io; use ada.text_io;

package body Courbes.Bezier.Quadratiques is
    function Ctor_Bezier_Quadratique (Debut, Fin, C : Point2D) return Bezier_Quadratique is
    begin
        return 
            new Bezier_Quadratique'(
                Debut => Debut,
                Fin => Fin,
                Controle => C);
    end;

    function Obtenir_Point(BC : Bezier_Quadratique; X : Float) return Point2D is
        Y : Float := 
            (1.0 - X) * (1.0 - X) * BC.Debut
            + 2.0 * X * (1.0 - X) * BC.Controle
            + X * X * BC.Fin; 
    begin 
        Put_Line("BC");
        return
            (Point2D'First => X, Point2D'Last => Y);
    end;
end Courbes.Bezier.Quadratiques;
