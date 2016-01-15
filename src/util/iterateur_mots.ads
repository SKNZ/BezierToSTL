package Iterateur_Mots is

    -- Regroupe les infos de la String
    type Iterateur_Mot is record
        Chaine : String;
        Curseur : Positive;
        Separateur : String;
    end record;

    -- Initialise le record
    procedure Initialiser_String(
        Chaine : String;
        Curseur : Positive;
        Separateur : String;
        Iterateur : out Iterateur_Mot);

    -- Lit le mot suivant (sans déplacer le curseur)
    function Lire_Mot_Suivant(
        Iterateur : Iterateur_Mot;
        Fin_Curseur : out Positive)
        return String;

    -- Avance au mot suivant (déplace le curseur)
    function Avancer_Mot_Suivant(Iterateur : Iterateur_Mot) return String;
end;
