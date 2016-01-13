package body Courbes is
    function Obtenir_Debut (C : Courbe) return Point2D is
    begin
        return C.Debut;
    end;

    function Obtenir_Fin (C : Courbe) return Point2D is
    begin
        return C.Fin;
    end;
end Courbes;
