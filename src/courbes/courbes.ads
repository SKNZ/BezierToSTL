with Vecteurs; use Vecteurs;
with Liste_Generique;
limited with Courbes.Visiteurs;

package Courbes is
    type Courbe is abstract tagged private;
    type Courbe_Ptr is access all Courbe'Class;
    package Liste_Courbes is new Liste_Generique(Courbe_Ptr);
    subtype Coordonnee_Normalisee is Float range 0.0 .. 1.0;

    procedure Liberer_Courbe (Self : in out Courbe_Ptr);

    -- Obtient un point à la coordonnée X fournie
    -- X entre 0 et 1 
    -- (x, f(x))
    -- Abstraite
    function Obtenir_Point(Self : Courbe; X : Coordonnee_Normalisee) return Point2D is abstract;

    -- Pattern visiteur
    procedure Accepter (Self : Courbe; Visiteur : Courbes.Visiteurs.Visiteur_Courbe'Class);

    -- Renvoie le debut d'une courbe
    function Obtenir_Debut(Self : Courbe) return Point2D;
    
    -- Renvoie la fin d'une courbe
    function Obtenir_Fin(Self : Courbe) return Point2D;
    
    private
    type Courbe is abstract tagged 
        record
            Debut, Fin : Point2D;
        end record;
end Courbes;
