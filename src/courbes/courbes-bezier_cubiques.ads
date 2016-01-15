with Courbes; use Courbes;

package Courbes.Bezier_Cubiques is
    use Liste_Points;
    type Bezier_Cubique is new Courbe with private;

    -- Crée une Bezier_Cubique
    function Ctor_Bezier_Cubique (Debut, Fin, C1, C2 : Point2D) return access Bezier_Cubique;
    
    -- Obtient un point d'une Bezier_Cubique
    overriding function Obtenir_Point(Self : Bezier_Cubique; X : Coordonnee_Normalisee) return Point2D;

    overriding procedure Visiter(Self : Bezier_Cubique; Visiteur : Courbes.Visiteurs.Visiteur_Courbe'Class);

    private

    type Bezier_Cubique_Controles is array (1 .. 2) of Point2D;

    type Bezier_Cubique is new Courbe with
        record
            Controles : Bezier_Cubique_Controles;
        end record;
end Courbes.Bezier_Cubiques;
