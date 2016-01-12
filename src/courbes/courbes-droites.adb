with ada.text_io; use ada.text_io;

package body Courbes.Droites is
    function Ctor_Droite (Debut, Fin : Point2D) return Droite is
    begin
        return (Debut => (others => 1.0), Fin => (others => 2.0));
    end;

    function Obtenir_Point(D : Droite; X : Float) return Point2D is
    begin
        Put_Line("D");
        return
            (Point2D'First => X, Point2D'Last => X);
    end;
end Courbes.Droites;
