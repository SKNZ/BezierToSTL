with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Iterateur_Mots is
    Erreur_Syntaxe : exception;

    type Iterateur_Mot is private;

    -- Initialise le record
    function Initialiser(Chaine : String; Separateur : Character) return Iterateur_Mot;

    -- Indique si l'iterateur est à sa fin
    function Fin(Iterateur : Iterateur_Mot) return Boolean;

    -- Lit le mot suivant (sans déplacer le curseur)
    -- lève Erreur_Syntaxe si caractère innatendu
    function Lire_Mot_Suivant(Iterateur : Iterateur_Mot) return String;

    -- Avance au mot suivant (déplace le curseur)
    function Avancer_Mot_Suivant(Iterateur : in out Iterateur_Mot) return String;

    private

    function Lire_Mot_Suivant_Interne(Iterateur : Iterateur_Mot; Caracteres_Lus : out Natural) return String;

    -- Regroupe les infos de la String
    type Iterateur_Mot is record
        Chaine : Unbounded_String;
        Curseur : Positive;
        Separateur : Character;
    end record;
end;
