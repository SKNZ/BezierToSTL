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

    type Op_Code is ('m', 'l', 'h', 'v', 'c', 'q', 'M', 'L', 'H', 'V', 'C', 'Q'); 
    subtype Op_Code_Relative is Op_Code range 'm' .. 'q'; 
    subtype Op_Code_Absolute is Op_Code range 'M' .. 'Q'; 


    -- Lit un opcode
    procedure Lire_OpCode (
        Iterateur : in out Iterateur_Mot;
        Op : out Op_Code);

    -- Execute l'opcode
    procedure Gerer_OpCode (
        Iterateur : in out Iterateur_Mot;
        Op : Op_Code;
        L : in out Liste);

    -- Valide le mot suivant comme opcode
    function Mot_Suivant_Est_Op_Code_Ou_Vide (Iterateur : Iterateur_Mot) return Boolean;

    -- Interprete le texte en tant qu'opcode
    -- True si success
    function Interpreter_Op_Code (Contenu : String; Op : in out Op_Code) return Boolean;
end;
