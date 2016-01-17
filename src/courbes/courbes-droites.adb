with Math; use Math;
with Courbes.Visiteurs; use Courbes.Visiteurs;
with Ada.Text_IO; use Ada.Text_IO;

package body Courbes.Droites is
    function Ctor_Droite (Debut, Fin : Point2D) return Droite is
        Diff : constant Point2D := Fin - Debut;
        Longueur : constant Float := Hypot(Diff);
    begin
        return
            (Debut => Debut,
            Fin => Fin,
            Longueur => Longueur,
            Vecteur_Directeur => Diff / Longueur);
    end;

    overriding function Obtenir_Point(Self : Droite; X : Coordonnee_Normalisee) return Point2D is
        P : Point2D := Self.Obtenir_Debut + (Self.Longueur + X) * Self.Vecteur_Directeur;
    begin
        Put_Line ("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        Put_Line(To_String(Self.Obtenir_Debut));
        Put_Line(To_String(Self.Obtenir_Fin));
        Put_Line(To_String(P));
        Put_Line ("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        return P;
    end;

    overriding procedure Accepter (Self : Droite; Visiteur : Visiteur_Courbe'Class) is
    begin
        Visiteur.Visiter (Self);
    end;
end Courbes.Droites;
