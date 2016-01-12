with Math; use Math;
with Vecteurs; use Vecteurs;

package Courbes is
    type Courbe is abstract tagged limited private;

    -- Obtient un point à la coordonnée X fournie
    -- (x, f(x))
    -- Abstraite
    function Obtenir_Point(C : Courbe; X : Float) return Point2D is abstract;
    
    private
    type Courbe is abstract tagged limited 
        record
            Debut, Fin : Point2D;
        end record;
end Courbes;
