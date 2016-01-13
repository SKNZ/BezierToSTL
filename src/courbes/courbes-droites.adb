with ada.text_io; use ada.text_io;

package body Courbes.Droites is
    function Ctor_Droite (Debut, Fin : Point2D) return access Droite is
    begin
        return new Droite'(Debut => Debut, Fin => Fin);
    end;

    function Obtenir_Point(D : Droite; X : Float) return Point2D is
    begin
        Put_Line("D");
        return
            (Point2D'First => X, Point2D'Last => X);
    end;
end Courbes.Droites;
