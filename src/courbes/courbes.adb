with Courbes.Visiteurs; use Courbes.Visiteurs;

package body Courbes is
    use Liste_Points;

    function Obtenir_Debut (Self : Courbe) return Point2D is
    begin
        return Self.Debut;
    end;

    function Obtenir_Fin (Self : Courbe) return Point2D is
    begin
        return Self.Fin;
    end;

    procedure Accepter (Self : Courbe; Visiteur : Courbes.Visiteurs.Visiteur_Courbe'Class) is
    begin
        Visiteur.Visiter(Self);
    end;
end Courbes;
