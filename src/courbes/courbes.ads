with Vecteurs; use Vecteurs;
with Liste_Generique;

package Courbes is
    type Courbe is abstract tagged private;
    type Courbe_Ptr is access all Courbe'Class;
    package Liste_Courbes is new Liste_Generique(Courbe_Ptr);

    -- Obtient un point à la coordonnée X fournie
    -- (x, f(x))
    -- Abstraite
    function Obtenir_Point(C : Courbe; X : Float) return Point2D is abstract;

    -- Pour rendre plus élégante l'utilisation avec parcourir
    -- On fournit une version générique de discretiser
    -- qui accepte une liste de segments et un nb de pts
    -- en paramètres génériques
    generic
        Segments : in out Liste_Points.Liste;
        Nombre_Points : Positive;
    procedure Discretiser_Gen(C : in out Courbe_Ptr);

    -- Discretise une courbe en N points
    procedure Discretiser(C : Courbe; Segments : in out Liste_Points.Liste; Nombre_Points : Positive) is abstract;

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
