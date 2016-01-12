with Vecteurs; use Vecteurs;

package Normalisation is
    use Liste_Points;

    -- Centre la figure sur l'axe X
    -- Raccorde les extremités de la figure à l'axe
    procedure Normaliser(Segments : in out Liste_Points.Liste);

    private
    -- Trouve les coordonnées minimum
    function Trouver_Coords_Min(Segments : in out Liste) return Point2D;
end normalisation;
