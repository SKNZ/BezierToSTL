with Iterateur_Mots; use Iterateur_Mots;
with Vecteurs; use Vecteurs;

package Helper is
    Erreur_Lecture : Exception;

    -- Cherche dans un fichier une ligne
    -- qui commence par la chaine donnée
    -- Renvoie la chaine trouvée SANS MARQUEUR
    -- avec un car. en moins à la fin (double quote)
    function Fichier_Ligne_Commence_Par(Nom_Fichier, Marqueur : String)
        return String;
        
    -- Lit une coordonnée
    function Lire_Coord(Iterateur : in out Iterateur_Mot) return Float;

    -- Lit un jeu de coordonnées
    procedure Lire_Point2D(
        Iterateur : in out Iterateur_Mot;
        Separateur_Coord : Character;
        Point : out Point2D);

    procedure Afficher_Debug (Afficher : Boolean);

    -- Affiche la chaine si debug activé
    procedure Debug (Chaine : String);

    -- Juste un new_line
    procedure Debug;

    private
    Etat_Debug : Boolean := False;
end Helper;
