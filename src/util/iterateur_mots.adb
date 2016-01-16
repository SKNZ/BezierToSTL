package body Iterateur_Mots is
    function Initialiser(
        Chaine : String;
        Separateur : Character)
        return Iterateur_Mot
    is
    begin
        return (Chaine => To_Unbounded_String(Chaine),
             Curseur => 1,
             Separateur => Separateur);
    end;

    function Fin(Iterateur : Iterateur_Mot) return Boolean is
    begin
        return Iterateur.Curseur > Length(Iterateur.Chaine);
    end;
    
    -- Obtient le texte entre le séparateur courant et le suivant
    -- Sans avancer le curseur
    -- Requiert Curseur = 1 ou Chaine (Curseur) = Separateur
    function Lire_Mot_Suivant(Iterateur : Iterateur_Mot) return String is
        Car_Lus : Positive;
    begin
        return Lire_Mot_Suivant_Interne(Iterateur, Car_Lus);
    end;

    -- Avance jusqu'au prochain séparateur et récupère le contenu
    -- Requiert Curseur = 1 ou Chaine (Curseur) = Separateur
    function Avancer_Mot_Suivant(Iterateur : in out Iterateur_Mot) return String is
        Caracteres_Lus : Natural := 0;

        Contenu : constant String := Lire_Mot_Suivant_Interne (Iterateur, Caracteres_Lus);
    begin
        Iterateur.Curseur := Caracteres_Lus;

        return Contenu;
    end;

    function Lire_Mot_Suivant_Interne(Iterateur : Iterateur_Mot; Caracteres_Lus : out Natural) return String
    is
        Contenu_Deb, Contenu_Fin : Positive := 1;
    begin
        if Iterateur.Curseur > Length(Iterateur.Chaine) then
            return "";
        end if;

        Caracteres_Lus := Iterateur.Curseur + 1;

        -- On vérifie que le car. courant est bien un séparateur
        -- On traite la chaine de séparateur en séparateur
        -- Cas particulier: quand Curseur = début, on ignore ce test
        if Iterateur.Curseur /= 1
            and then Element(Iterateur.Chaine, Iterateur.Curseur) /= Iterateur.Separateur
        then
            raise Erreur_Syntaxe with
            "Carac. inattendu (courant /= séparateur): L("
            & Positive'Image(Iterateur.Curseur)
            & ") = "
            & Element(Iterateur.Chaine, Iterateur.Curseur)
            & " /= "
            & Iterateur.Separateur;
        end if;

        -- On avance jusqu'à trouver le prochain séparateur
        -- ou jusqu'à la fin de la chaine
        while Caracteres_Lus <= Length(Iterateur.Chaine)
            and then Element(Iterateur.Chaine, Caracteres_Lus) /= Iterateur.Separateur loop
            Caracteres_Lus := Caracteres_Lus + 1;
        end loop;

        Contenu_Deb := Iterateur.Curseur;
        Contenu_Fin := Caracteres_Lus;

        -- Si on n'est pas à la fin de la chaîne
        -- alors la fin du contenu est
        -- 1 car. avant le séparateur suivant
        if Caracteres_Lus /= Length(Iterateur.Chaine) then
            Contenu_Fin := Contenu_Fin - 1;
        end if;

        -- Si on n'est pas au début de la chaîne
        -- alors le début du contenu est
        -- 1 car. après le séparateur précedent
        if Iterateur.Curseur /= 1 then
            Contenu_Deb := Contenu_Deb + 1;
        end if;

        return Slice(Iterateur.Chaine, Contenu_Deb, Contenu_Fin);
    end;
end;
