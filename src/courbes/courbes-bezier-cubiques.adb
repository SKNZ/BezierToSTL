with ada.text_io; use ada.text_io;

package body Courbes.Bezier.Cubiques is
    function Ctor_Bezier_Cubique (Debut, Fin, C1, C2 : Point2D) return Bezier_Quadratique is
        Controles : Bezier_Cubique_Controles :=
            (Controles'First => C1,
            Controles'First => C2);
    begin
        return 
            (Debut => Debut,
            Fin => Fin,
            Controles => Controles);
    end;

    function Obtenir_Point(BC : Bezier_Cubique; X : Float) return Point2D is
    begin 
        Put_Line("BC");
        return
            (Point2D'First => X, Point2D'Last => X);
    end;
end Courbes.Bezier.Cubiques;
