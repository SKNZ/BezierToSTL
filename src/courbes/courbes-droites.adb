with Math; use Math;

package body Courbes.Droites is
    function Ctor_Droite (Debut, Fin : Point2D) return access Droite is
        Diff : constant Point2D := Fin - Debut;
        Longueur : constant Float := Hypot(Diff);
    begin
        return new Droite'(
            Debut => Debut,
            Fin => Fin,
            Longueur => Longueur,
            Vecteur_Normal => Diff / Longueur);
    end;

    function Obtenir_Point(D : Droite; X : Coordonnee_Normalisee) return Point2D is
    begin
        return D.Obtenir_Debut + X * D.Vecteur_Normal;
    end;
end Courbes.Droites;
