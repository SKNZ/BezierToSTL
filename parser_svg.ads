with Math; use Math;

package Parser_Svg is
    use Liste_Points;

    Courbe_Abs : exception;
    Courbe_Illisible : exception;

    --parse un fichier svg et retourne une liste de points (voir documentation)
    -- lève Courbe_Abs si pas de courbe trouvée
    -- lève Courbe_Illisible si erreur de syntaxe
    procedure Chargement_Bezier(Nom_Fichier : String; L : out Liste);

    private

    Marqueur_Ligne : constant String := "d=""";
    Separateur : constant Character := ' ';
    Separateur_Coord : constant Character := ',';
    Separateur_Decimal : constant Character := '.';

    type Op_Code is ('m', 'l', 'h', 'v', 'c', 'q', 'M', 'L', 'H', 'V', 'C', 'Q'); 
    subtype Op_Code_Relative is Op_Code range 'm' .. 'q'; 
    subtype Op_Code_Absolute is Op_Code range 'M' .. 'Q'; 
end;
