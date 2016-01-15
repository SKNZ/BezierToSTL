package body Iterateur_Mots is

    procedure Initialiser_String(
        Chaine : Unbounded_String;
        Curseur : Positive;
        Separateur : Character;
        Iterateur : out Iterateur_Mot)
    is
    begin
        Iterateur :=
            (Chaine => Chaine,
             Curseur => Curseur,
             Separateur => Separateur);
    end;
    
    -- Obtient le texte entre le séparateur courant et le suivant
    -- Sans avancer le curseur
    -- Requiert Curseur = 1 ou Chaine (Curseur) = Separateur
    function Lire_Mot_Suivant(
        Iterateur : Iterateur_Mot;
        Fin_Curseur : out Positive)
        return String
    is
        Contenu_Deb, Contenu_Fin : Positive := To_String(Iterateur.Chaine)'First;
    begin
        if Iterateur.Curseur > To_String(Iterateur.Chaine)'Length then
            return "";
        end if;

        Fin_Curseur := Iterateur.Curseur + 1;

        -- On vérifie que le car. courant est bien un séparateur
        -- On traite la chaine de séparateur en séparateur
        -- Cas particulier: quand Curseur = début, on ignore ce test
        if Iterateur.Curseur /= To_String(Iterateur.Chaine)'First
            and then To_String(Iterateur.Chaine)(Iterateur.Curseur) /= Iterateur.Separateur
        then
            raise Courbe_Illisible with "Carac. inattendu (courant /= séparateur): L(" & Positive'Image(Iterateur.Curseur) & ") = " & To_String(Iterateur.Chaine)(Iterateur.Curseur) & " /= " & Iterateur.Separateur;
        end if;

        -- On avance jusqu'à trouver le prochain séparateur
        -- ou jusqu'à la fin de la chaine
        while Fin_Curseur <= To_String(Iterateur.Chaine)'Last
            and then To_String(Iterateur.Chaine)(Fin_Curseur) /= Iterateur.Separateur loop
            Fin_Curseur := Fin_Curseur + 1;
        end loop;

        Contenu_Deb := Iterateur.Curseur;
        Contenu_Fin := Fin_Curseur;

        -- Si on n'est pas à la fin de la chaîne
        -- alors la fin du contenu est
        -- 1 car. avant le séparateur suivant
        if Fin_Curseur /= To_String(Iterateur.Chaine)'Last then
            Contenu_Fin := Contenu_Fin - 1;
        end if;

        -- Si on n'est pas au début de la chaîne
        -- alors le début du contenu est
        -- 1 car. après le séparateur précedent
        if Iterateur.Curseur /= To_String(Iterateur.Chaine)'First then
            Contenu_Deb := Contenu_Deb + 1;
        end if;

        return To_String(Iterateur.Chaine)(Contenu_Deb .. Contenu_Fin);
    end;

    -- Avance jusqu'au prochain séparateur et récupère le contenu
    -- Requiert Curseur = 1 ou Chaine (Curseur) = Separateur
    function Avancer_Mot_Suivant(Iterateur : in out Iterateur_Mot) return String is
        Fin_Curseur : Positive;
        Contenu : constant String := Lire_Mot_Suivant (Iterateur, Fin_Curseur);
    begin
        Iterateur.Curseur := Fin_Curseur;

        return Contenu;
    end;
end;
