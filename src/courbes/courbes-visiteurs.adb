package body Courbes.Visiteurs is
    procedure Visiter(Self : Visiteur_Courbe; C : Courbe) is
    begin
        null;
    end;

    procedure Visiter(Self : Visiteur_Courbe; D : Droite) is
    begin
        null;
    end;

    procedure Visiter(Self : Visiteur_Courbe; S : Singleton) is
    begin
        null;
    end;

    procedure Visiter(Self : Visiteur_Courbe; BC : Bezier_Cubique) is
    begin
        null;
    end;

    procedure Visiter(Self : Visiteur_Courbe; BQ : Bezier_Quadratique) is
    begin
        null;
    end;
end Courbes.Visiteurs;
