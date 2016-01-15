with Math; use Math;
with Courbes.Visiteurs; use Courbes.Visiteurs;

package body Courbes.Droites is
    function Ctor_Droite (Debut, Fin : Point2D) return access Droite is
        Diff : constant Point2D := Fin - Debut;
        Longueur : constant Float := Hypot(Diff);
    begin
        return new Droite'(
            Debut => Debut,
            Fin => Fin,
            Longueur => Longueur,
            Vecteur_Directeur => Diff / Longueur);
    end;

    overriding function Obtenir_Point(Self : Droite; X : Coordonnee_Normalisee) return Point2D is
    begin
        return Self.Obtenir_Debut + X * Self.Vecteur_Directeur;
    end;

    overriding procedure Accepter (Self : Droite; Visiteur : Visiteur_Courbe'Class) is
    begin
        Visiteur.Visiter (Self);
    end;
end Courbes.Droites;
