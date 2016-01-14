package Courbes.Droites is
    use Liste_Points;
    type Droite is new Courbe with private;

    -- Crée une droite
    function Ctor_Droite (Debut, Fin : Point2D) return access Droite;

    -- Obtient un point d'une droite
    function Obtenir_Point(D : Droite; X : Coordonnee_Normalisee) return Point2D;

    private

    type Droite is new Courbe with
        record
            -- Longueur de la droite
            Longueur : Float;

            -- Vecteur normal
            Vecteur_Normal : Point2D;
        end record;
end Courbes.Droites;
