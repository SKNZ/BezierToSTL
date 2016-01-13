with Math; use Math;
with Vecteurs; use Vecteurs;

package Courbes is
    type Courbe is abstract tagged private;

    -- Obtient un point à la coordonnée X fournie
    -- (x, f(x))
    -- Abstraite
    function Obtenir_Point(C : Courbe; X : Float) return Point2D is abstract;

    function Obtenir_Debut(C : Courbe) return Point2D;
    function Obtenir_Fin(C : Courbe) return Point2D;
    
    private
    type Courbe is abstract tagged 
        record
            Debut, Fin : Point2D;
        end record;
end Courbes;
