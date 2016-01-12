with Courbes; use Courbes;
with Vecteurs; use Vecteurs;

package Courbes.Bezier.Cubiques is
    type Bezier_Cubique is new Courbe with private;

    -- Crée une Bezier_Cubique
    function Ctor_Bezier_Cubique (Debut, Fin, C1, C2 : Point2D) return Bezier_Cubique;

    -- Obtient un point d'une Bezier_Cubique
    function Obtenir_Point(D : Bezier_Cubique; X : Float) return Point2D;

    private

    type Bezier_Cubique_Controles is array (1 .. 2) of Point2D;

    type Bezier_Cubique is new Courbe with record
        record
            Controles : Bezier_Cubique_Controles;
        end record;
end Courbes.Bezier.Cubiques;
