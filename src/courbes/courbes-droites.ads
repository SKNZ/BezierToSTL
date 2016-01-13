package Courbes.Droites is
    use Liste_Points;
    type Droite is new Courbe with private;

    -- Crée une droite
    function Ctor_Droite (Debut, Fin : Point2D) return access Droite;

    -- Obtient un point d'une droite
    function Obtenir_Point(D : Droite; X : Float) return Point2D;

    -- Discretise une droite en 2 points
    -- Nombre_points ignoré
    procedure Discretiser(D : Droite; Segments : in out Liste_Points.Liste; Nombre_Points : Positive);

    private

    type Droite is new Courbe with null record;
end Courbes.Droites;
