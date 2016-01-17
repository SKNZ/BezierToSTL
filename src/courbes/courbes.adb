with Ada.Unchecked_Deallocation;
with Courbes.Visiteurs; use Courbes.Visiteurs;

package body Courbes is
    use Liste_Points;

    procedure Liberer_Courbe (Self : in out Courbe_Ptr) is
        procedure Liberer_Delivrer is new Ada.Unchecked_Deallocation (Courbe'Class, Courbe_Ptr);
    begin
        -- Libération de la memoire allouée par le Ctor
        -- Note: cela fonctionne aussi sur les types dérivés
        Liberer_Delivrer (Self);
    end;

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
