package body Courbes.Singletons is
    function Ctor_Singleton (P : Point2D) return access Singleton is
    begin
        return new Singleton'(Debut => P, Fin => P);
    end;

    -- X pas utilisé
    function Obtenir_Point(S : Singleton; X : Coordonnee_Normalisee) return Point2D is
    begin 
        return S.Debut;
    end;

    -- Nombre_Points pas utilisé
    procedure Interpolation_Lineaire(S : Singleton; Segments : in out Liste_Points.Liste; Nombre_Points : Positive) is
    begin
        Insertion_Queue(Segments, S.Obtenir_Debut);
    end;
end Courbes.Singletons;
