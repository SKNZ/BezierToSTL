package Courbes.Droites is
    use Liste_Points;
    type Droite is new Courbe with private;

    -- Crée une droite
    function Ctor_Droite (Debut, Fin : Point2D) return access Droite;

    -- Obtient un point d'une droite
    overriding function Obtenir_Point(Self : Droite; X : Coordonnee_Normalisee) return Point2D;

    overriding procedure Accepter (Self : Droite; Visiteur : Courbes.Visiteurs.Visiteur_Courbe'Class);

    private

    type Droite is new Courbe with
        record
            -- Longueur de la droite
            Longueur : Float;

            -- Vecteur normal
            Vecteur_Directeur : Point2D;
        end record;
end Courbes.Droites;
