with Courbes; use Courbes;

package Courbes.Bezier.Quadratiques is
    use Liste_Points;
    type Bezier_Quadratique is new Courbe with private;

    -- Créer une Bezier_Quadratique
    function Ctor_Bezier_Quadratique (Debut, Fin, C : Point2D) return access Bezier_Quadratique;

    -- Obtient un point d'une Bezier_Quadratique
    function Obtenir_Point(BQ : Bezier_Quadratique; X : Float) return Point2D;

    -- Discretise une courbe en N points
    procedure Discretiser(BQ : Bezier_Quadratique; Segments : in out Liste_Points.Liste; Nombre_Points : Positive);

    private

    type Bezier_Quadratique is new Courbe with
        record
            Controle : Point2D;
        end record;
end Courbes.Bezier.Quadratiques;
