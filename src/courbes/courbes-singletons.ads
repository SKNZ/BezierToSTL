with Courbes; use Courbes;
with Vecteurs; use Vecteurs;

package Courbes.Singletons is
    type Singleton is new Courbe with private;

    -- Crée un singleton
    function Ctor_Singleton (P : Point2D) return access Singleton;

    -- Obtient un point d'un singleton
    function Obtenir_Point(S : Singleton; X : Float) return Point2D;

    private

    type Singleton is new Courbe with null record;
end Courbes.Singletons;
