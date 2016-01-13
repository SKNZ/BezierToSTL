with Courbes; use Courbes;
with Vecteurs; use Vecteurs;

package Courbes.Bezier.Quadratiques is
    type Bezier_Quadratique is new Courbe with private;

    -- Créer une Bezier_Quadratique
    function Ctor_Bezier_Quadratique (Debut, Fin, C : Point2D) return access Bezier_Quadratique;

    -- Obtient un point d'une Bezier_Quadratique
    function Obtenir_Point(D : Bezier_Quadratique; X : Float) return Point2D;

    private

    type Bezier_Quadratique is new Courbe with
        record
            Controle : Point2D;
        end record;
end Courbes.Bezier.Quadratiques;
