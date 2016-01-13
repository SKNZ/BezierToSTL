package body Courbes.Droites is
    function Ctor_Droite (Debut, Fin : Point2D) return access Droite is
    begin
        return new Droite'(Debut => Debut, Fin => Fin);
    end;

    function Obtenir_Point(D : Droite; X : Float) return Point2D is
    begin
        return
            (Point2D'First => X, Point2D'Last => X);
    end;

    -- Nombre_Points pas utilisé
    -- normal c'est un segment
    procedure Discretiser(D : Droite; Segments : in out Liste_Points.Liste; Nombre_Points : Positive) is
    begin
        Insertion_Queue(Segments, D.Obtenir_Debut);
        Insertion_Queue(Segments, D.Obtenir_Fin);
    end;
end Courbes.Droites;
