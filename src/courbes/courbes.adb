package body Courbes is
    function Obtenir_Debut (C : Courbe) return Point2D is
    begin
        return C.Debut;
    end;

    function Obtenir_Fin (C : Courbe) return Point2D is
    begin
        return C.Fin;
    end;

    procedure Discretiser_Gen(C : in out Courbe_Ptr) is
    begin
        C.Discretiser (Segments, Nombre_Points);
    end;
end Courbes;
