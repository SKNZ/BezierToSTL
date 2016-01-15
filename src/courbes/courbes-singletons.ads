with Courbes; use Courbes;

package Courbes.Singletons is
    use Liste_Points;
    type Singleton is new Courbe with private;

    -- Crée un singleton
    function Ctor_Singleton (P : Point2D) return access Singleton;

    overriding procedure Visiter(Self : Singleton; Visiteur : Courbes.Visiteurs.Visiteur_Courbe'Class);

    -- Obtient un point d'un singleton
    overriding function Obtenir_Point(Self : Singleton; X : Coordonnee_Normalisee) return Point2D;

    private

    type Singleton is new Courbe with null record;
end Courbes.Singletons;
