with Courbes.Visiteurs; use Courbes.Visiteurs;

package body Courbes.Bezier_Cubiques is
    function Obtenir_Controle1 (Self : Bezier_Cubique) return Point2D is
    begin
        return Self.Controles (1);
    end;

    function Obtenir_Controle2 (Self : Bezier_Cubique) return Point2D is
    begin
        return Self.Controles (2);
    end;

    function Ctor_Bezier_Cubique (Debut, Fin, C1, C2 : Point2D) return Bezier_Cubique is
        Controles : constant Bezier_Cubique_Controles :=
            (1 => C1,
            2 => C2);
    begin
        return
            (Debut => Debut,
            Fin => Fin,
            Controles => Controles);
    end;

    overriding function Obtenir_Point(Self : Bezier_Cubique; X : Coordonnee_Normalisee) return Point2D is
    begin 
        return
            (1.0 - X) ** 3 * Self.Debut 
            + 3.0 * X * (1.0 - X) ** 2 * Self.Controles (1)
            + 3.0 * X ** 2 * (1.0 - X) * Self.Controles (2) 
            + X ** 3 * Self.Fin; 
    end;

    overriding procedure Accepter (Self : Bezier_Cubique; Visiteur : Visiteur_Courbe'Class) is
    begin
        Visiteur.Visiter (Self);
    end;
end Courbes.Bezier_Cubiques;
