with Vecteurs; use Vecteurs;
with Liste_Generique;

package Courbes is
    type Courbe is abstract tagged private;
    type Courbe_Ptr is access all Courbe'Class;
    package Liste_Courbes is new Liste_Generique(Courbe_Ptr);

    -- Obtient un point à la coordonnée X fournie
    -- X entre 0 et (Fin.X - Debut.X)
    -- (x, f(x))
    -- Abstraite
    function Obtenir_Point(C : Courbe; X : Float) return Point2D is abstract;


    -- Discretise une courbe en N points
    procedure Interpolation_Lineaire(C : Courbe; Segments : in out Liste_Points.Liste; Nombre_Points : Positive);

    -- Renvoie le debut d'une courbe
    function Obtenir_Debut(C : Courbe) return Point2D;
    
    -- Renvoie la fin d'une courbe
    function Obtenir_Fin(C : Courbe) return Point2D;
    
    private
    type Courbe is abstract tagged 
        record
            Debut, Fin : Point2D;
        end record;
end Courbes;
