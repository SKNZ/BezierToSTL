with ada.text_io; use ada.text_io;

package body Courbes.Bezier.Quadratiques is
    function Ctor_Bezier_Quadratique (Debut, Fin, C : Point2D) return Bezier_Quadratique is
    begin
        return 
            (Debut => Debut,
            Fin => Fin,
            Controle => C);
    end;

    function Obtenir_Point(BC : Bezier_Quadratique; X : Float) return Point2D is
    begin 
        Put_Line("BC");
        return
            (Point2D'First => X, Point2D'Last => X);
    end;
end Courbes.Bezier.Quadratiques;
