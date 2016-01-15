with Courbes; use Courbes;

package Courbes.Bezier_Quadratiques is
    use Liste_Points;
    type Bezier_Quadratique is new Courbe with private;

    -- Créer une Bezier_Quadratique
    function Ctor_Bezier_Quadratique (Debut, Fin, C : Point2D) return access Bezier_Quadratique;

    -- Obtient un point d'une Bezier_Quadratique
    overriding function Obtenir_Point(Self : Bezier_Quadratique; X : Coordonnee_Normalisee) return Point2D;

    overriding procedure Accepter (Self : Bezier_Quadratique; Visiteur : Courbes.Visiteurs.Visiteur_Courbe'Class);

    private

    type Bezier_Quadratique is new Courbe with
        record
            Controle : Point2D;
        end record;
end Courbes.Bezier_Quadratiques;
