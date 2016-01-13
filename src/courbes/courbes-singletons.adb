with ada.text_io; use ada.text_io;

package body Courbes.Singletons is
    function Ctor_Singleton (P : Point2D) return Point is
    begin
        return new Singleton'(Debut => P, Fin => P);
    end;

    function Obtenir_Point(BC : Singleton; X : Float) return Point2D is
    begin 
        Put_Line("S");
        return BC.Debut;
    end;
end Courbes.Singletons;
