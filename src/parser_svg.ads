with Vecteurs; use Vecteurs;
with Courbes; use Courbes;
with Iterateur_Mots; use Iterateur_Mots;

package Parser_Svg is
    use Liste_Courbes;

    Courbe_Abs : exception;
    Courbe_Illisible : exception;

    --parse un fichier svg et retourne une liste de points (voir documentation)
    -- lève Courbe_Abs si pas de courbe trouvée
    -- lève Courbe_Illisible si erreur de syntaxe
    procedure Charger_SVG(Nom_Fichier : String; L : out Liste);

    private

    Marqueur_Ligne : constant String := "d=""";
    Separateur : constant Character := ' ';
    Separateur_Coord : constant Character := ',';
    Separateur_Decimal : constant Character := '.';

    type Op_Code is ('m', 'l', 'h', 'v', 'c', 'q', 'M', 'L', 'H', 'V', 'C', 'Q'); 
    subtype Op_Code_Relative is Op_Code range 'm' .. 'q'; 
    subtype Op_Code_Absolute is Op_Code range 'M' .. 'Q'; 

    -- Trouve la ligne D
    function Trouver_Ligne_D(
        Nom_Fichier : String)
        return String;

    -- Lit un opcode
    procedure Lire_OpCode (
        Iterateur : in out Iterateur_Mot;
        Op_Abs : out Op_Code_Absolute;
        Relatif_Vers_Absolu : out Boolean);

    -- Execute l'opcode
    procedure Gerer_OpCode (
        Iterateur : in out Iterateur_Mot;
        Position_Courante : in out Point2D;
        Op : Op_Code_Absolute;
        L : in out Liste;
        Relatif_Vers_Absolu : Boolean);

    -- Valide le mot suivant comme opcode
    function Mot_Suivant_Est_Op_Code_Ou_Vide (
        Iterateur : Iterateur_Mot)
        return Boolean;

    -- Lit une coordonnée
    function Lire_Coord(
        Iterateur : in out Iterateur_Mot)
        return Float;

    -- Lit un jeu de coordonnées
    procedure Lire_Point2D(
        Iterateur : in out Iterateur_Mot;
        Point : out Point2D);
end;
