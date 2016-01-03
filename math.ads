with Liste_Generique;

package Math is
    Nombre_Facettes : constant Positive := 60;

    type Vecteur is array(Positive range<>) of Float;
    subtype Point2D is Vecteur(1..2);
    package Liste_Points is new Liste_Generique(Point2D);
    use Liste_Points;

    -- Affiche UN point
    procedure Display(P : in out Point2D);

    -- Affiche TOUT les points d'une liste
    procedure Afficher is new Parcourir(Traiter => Display);

    -- convertit une courbe de Bezier cubique en segments
    procedure Bezier(P1, C1, C2, P2 : Point2D ; Nb_Points : Positive ;
        Points : in out Liste);

    -- convertit une courbe de Bezier quadratique en segments
    procedure Bezier(P1, C, P2 : Point2D ; Nb_Points : Positive ;
        Points : in out Liste);

    -- addition de 2 vecteurs
    -- Requiert A, B de taille identique
    function "+" (A : Vecteur ; B : Vecteur) return Vecteur;

    -- multiplication scalaire vecteur
    function "*" (Facteur : Float ; V : Vecteur) return Vecteur;

    private
    -- Retourne un point d'une courbe de Bézier quadratique
    -- Requiert X dans (0,1)
    function Bezier_Quad(P1, C, P2 : Point2D; X : Float) return Point2D;

    -- Retourne un point d'une courbe de Bézier cubique
    -- Requiert X dans (0,1)
    function Bezier_Cub(P1, C1, C2, P2 : Point2D; X : Float) return Point2D;
end;
