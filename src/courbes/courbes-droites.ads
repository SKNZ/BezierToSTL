package Courbes.Droites is
    type Droite is new Courbe with private;

    -- Crée une droite
    function Ctor_Droite (Debut, Fin : Point2D) return Droite;

    -- Obtient un point d'une droite
    function Obtenir_Point(D : Droite; X : Float) return Point2D;

    private

    type Droite is new Courbe with null record;
end Courbes.Droites;
