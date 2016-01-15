with Courbes.Visiteurs; use Courbes.Visiteurs;

package body Courbes.Bezier_Quadratiques is
    function Ctor_Bezier_Quadratique (Debut, Fin, C : Point2D) return access Bezier_Quadratique is
    begin
        return 
            new Bezier_Quadratique'(
                Debut => Debut,
                Fin => Fin,
                Controle => C);
    end;

    overriding function Obtenir_Point(Self : Bezier_Quadratique; X : Coordonnee_Normalisee) return Point2D is
    begin 
        return
            (1.0 - X) ** 2 * Self.Debut
            + 2.0 * X * (1.0 - X) * Self.Controle
            + X ** 2 * Self.Fin; 
    end;

    overriding procedure Accepter (Self : Bezier_Quadratique; Visiteur : Visiteur_Courbe'Class) is
    begin
        Visiteur.Accepter (Self);
    end;
end Courbes.Bezier_Quadratiques;
