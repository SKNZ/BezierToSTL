with Courbes; use Courbes;

package Courbes.Singletons is
    use Liste_Points;
    type Singleton is new Courbe with private;

    -- Crée un singleton
    function Ctor_Singleton (P : Point2D) return access Singleton;

    -- Obtient un point d'un singleton
    function Obtenir_Point(S : Singleton; X : Float) return Point2D;

    -- Discretise un singleton (en un point) 
    -- Nombre_points ignoré
    procedure Discretiser(S : Singleton; Segments : in out Liste_Points.Liste; Nombre_Points : Positive);

    private

    type Singleton is new Courbe with null record;
end Courbes.Singletons;
