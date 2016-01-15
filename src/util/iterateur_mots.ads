with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Iterateur_Mots is

    Courbe_Illisible : exception;

    -- Regroupe les infos de la String
    type Iterateur_Mot is record
        Chaine : Unbounded_String;
        Curseur : Positive;
        Separateur : Character;
    end record;

    -- Initialise le record
    procedure Initialiser_String(
        Chaine : Unbounded_String;
        Curseur : Positive;
        Separateur : Character;
        Iterateur : out Iterateur_Mot);

    -- Lit le mot suivant (sans déplacer le curseur)
    -- lève Courbe_Illisible si caractère innatendu
    function Lire_Mot_Suivant(
        Iterateur : Iterateur_Mot;
        Fin_Curseur : out Positive)
        return String;

    -- Avance au mot suivant (déplace le curseur)
    function Avancer_Mot_Suivant(Iterateur : in out Iterateur_Mot) return String;
end;
