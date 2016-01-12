with Vecteurs; use Vecteurs;

package Math is
    use Liste_Points;
    Nombre_Points_Bezier : constant Positive := 50;

    -- convertit une courbe de Bezier cubique en segments
    procedure Bezier(P1, C1, C2, P2 : Point2D ; Nb_Points : Positive ;
        Points : in out Liste);

    -- convertit une courbe de Bezier quadratique en segments
    procedure Bezier(P1, C, P2 : Point2D ; Nb_Points : Positive ;
        Points : in out Liste);

    private
    -- Retourne un point d'une courbe de Bézier quadratique
    -- Requiert X dans (0,1)
    function Bezier_Quad(P1, C, P2 : Point2D; X : Float) return Point2D;

    -- Retourne un point d'une courbe de Bézier cubique
    -- Requiert X dans (0,1)
    function Bezier_Cub(P1, C1, C2, P2 : Point2D; X : Float) return Point2D;
end;
