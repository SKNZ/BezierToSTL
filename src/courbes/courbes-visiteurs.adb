package body Courbes.Visiteurs is
    procedure Visiter(Self : Visiteur_Courbe; C : Courbe) is
    begin
        null;
    end;

    -- En absence d'override, on se ramène au type parent
    -- C'est à dire la courbe
    -- Et pour profiter d'une éventuel surcharge dans héritage, on redispatch

    procedure Visiter(Self : Visiteur_Courbe; D : Droite) is
        -- Redispatching
        CSelf : constant Visiteur_Courbe'Class := Self;
    begin
        CSelf.Visiter(Courbe(D));
    end;

    procedure Visiter(Self : Visiteur_Courbe; S : Singleton) is
        -- Redispatching
        CSelf : constant Visiteur_Courbe'Class := Self;
    begin
        CSelf.Visiter(Courbe(S));
    end;

    procedure Visiter(Self : Visiteur_Courbe; BC : Bezier_Cubique) is
        -- Redispatching
        CSelf : constant Visiteur_Courbe'Class := Self;
    begin
        CSelf.Visiter(Courbe(BC));
    end;

    procedure Visiter(Self : Visiteur_Courbe; BQ : Bezier_Quadratique) is
        -- Redispatching
        CSelf : constant Visiteur_Courbe'Class := Self;
    begin
        CSelf.Visiter(Courbe(BQ));
    end;
end Courbes.Visiteurs;
