with Ada.Text_IO, Ada.Float_Text_IO, Ada.Characters.Handling, Ada.Strings, Ada.Strings.Fixed, Ada.Strings.Unbounded, math;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Characters.Handling, Ada.Strings, Ada.Strings.Fixed, Ada.Strings.Unbounded, math;

package body Parser_Svg is
    function Get_Ligne_D(
        Nom_Fichier : String)
        return String
    is
        Ligne_D : Unbounded_String := Null_Unbounded_String;
        Fichier : Ada.Text_IO.File_Type;
    begin
        -- On ouvre le fichier
        Ada.Text_IO.Open (Fichier, Ada.Text_IO.In_File, Nom_Fichier);

        -- On s'arrête qd la ligne est trouvée ou à la fin du fichier
        while Length(Ligne_D) = 0
            and then not Ada.Text_IO.End_Of_File (Fichier) loop
            declare
                -- On obtient une ligne, et on enlève les espaces en début/fin
                Ligne : String := Trim (Ada.Text_IO.Get_Line (Fichier), Both);
            begin
                -- on récupère la ligne commençant par "d="
                if Ligne'Length >= Marqueur_Ligne'Length and then Ligne (Marqueur_Ligne'Range) = Marqueur_Ligne then
                    Ligne_D := To_Unbounded_String (Ligne (Ligne'First + Marqueur_Ligne'Length .. Ligne'Last - 1));
                end if;
            end;
        end loop;

        -- Fermeture du fichier
        Ada.Text_IO.Close (Fichier);

        -- Si on a pas trouvé de ligne 
        if Length(Ligne_D) = 0 then
            raise Courbe_Abs;
        end if;

        return To_String (Ligne_D);
    end;

    -- Obtient le texte entre le séparateur courant et le suivant
    -- Sans avancer le curseur
    -- Requiert Curseur = 1 ou Ligne_D (Curseur) = Separateur
    function Voir_Au_Separateur(
        Ligne_D : String;
        Curseur : in Positive;
        Fin_Curseur : out Positive)
        return String
    is
        Contenu_Deb, Contenu_Fin : Positive := Ligne_D'First;
    begin
        if Curseur > Ligne_D'Length then
            return "";
        end if;

        Fin_Curseur := Curseur + 1;

        -- On vérifie que le car. courant est bien un séparateur
        -- On traite la chaine de séparateur en séparateur
        -- Cas particulier: quand Curseur = début, on ignore ce test
        if Curseur /= Ligne_D'First
            and then Ligne_D (Curseur) /= Separateur
        then
            raise Courbe_Illisible with "Mauvais Curseurnement (courant /= séparateur): L(" & Positive'Image(Curseur) & ") = " & Ligne_D (Curseur) & " /= " & Separateur;
        end if;

        -- On avance jusqu'à trouver le prochain séparateur
        -- ou jusqu'à la fin de la chaine
        while Fin_Curseur <= Ligne_D'Last
            and then Ligne_D (Fin_Curseur) /= Separateur loop
            Fin_Curseur := Fin_Curseur + 1;
        end loop;

        Contenu_Deb := Curseur;
        Contenu_Fin := Fin_Curseur;

        -- Si on n'est pas à la fin de la chaîne
        -- alors la fin du contenu est
        -- 1 car. avant le séparateur suivant
        if Fin_Curseur /= Ligne_D'Last then
            Contenu_Fin := Contenu_Fin - 1;
        end if;

        -- Si on n'est pas au début de la chaîne
        -- alors le début du contenu est
        -- 1 car. après le séparateur précedent
        if Curseur /= Ligne_D'First then
            Contenu_Deb := Contenu_Deb + 1;
        end if;

        return Ligne_D (Contenu_Deb .. Contenu_Fin);
    end;

    -- Avance jusqu'au prochain séparateur et récupère le contenu
    -- Requiert Curseur = 1 ou Ligne_D (Curseur) = Separateur
    function Avancer_Au_Separateur(
        Ligne_D : String;
        Curseur : in out Positive)
        return String
    is
        Fin_Curseur : Positive;
        Contenu : String := Voir_Au_Separateur (Ligne_D, Curseur, Fin_Curseur);
    begin
        Curseur := Fin_Curseur;

        return Contenu;
    end;

    procedure Lire_Point2D(
        Ligne_D : String;
        Curseur : in out Positive;
        Point : in out Point2D)
    is
        Contenu : String := Avancer_Au_Separateur(Ligne_D,  Curseur);

        X, Y : Float;
    begin
        -- On cherche la Curseur du
        -- séparateur d'un jeu de coordonnées
        declare
            Separateur_Curseur : Positive := Contenu'First;
        begin
            -- On cherche le séparateur
            -- On s'arrête si on est à la fin de la chaine
            -- ou si on trouve le séparateur
            while Separateur_Curseur <= Contenu'Last
                and then Contenu (Separateur_Curseur) /= Separateur_Coord loop
                -- On avance
                Separateur_Curseur := Separateur_Curseur + 1;
            end loop;

            -- Le séparateur est à la fin ou au début
            -- il n'y a rien après
            -- et il manque une information
            if Separateur_Curseur = Contenu'Last 
                or else Separateur_Curseur = Contenu'First then
                raise Courbe_Illisible with "Manque deuxième coordonnée";
            end if;

            declare
                -- On récupère la première coordonnée
                X_Text : String := Contenu (Contenu'First .. Separateur_Curseur - 1);
                -- On récupère la deuxième coordonnée
                Y_Text : String := Contenu (Separateur_Curseur + 1 .. Contenu'Last);
            begin
                -- Conversion en flottant
                X := Float'Value (X_Text);
                Y := Float'Value (Y_Text);
            exception
                when Constraint_Error =>
                    -- Si les nombres sont mal formés...
                    raise Courbe_Illisible with "Nombre flottant mal formé";
            end;
        end;

        Point := (1 => Point(1) + X, 2 => Point(2) + Y);        
    end;

    function Lire_Coord(
        Ligne_D : String;
        Curseur : in out Positive)
        return Float
    is
        Contenu : String := Avancer_Au_Separateur(Ligne_D, Curseur);
    begin
        -- On transforme le contenu en flottant
        return Float'Value (Contenu);
    exception
        when Constraint_Error =>
            -- Si les nombres sont mal formés...
            raise Courbe_Illisible with "Flottant mal formé";
    end;

    procedure Lire_OpCode (
        Ligne_D : String;
        Curseur : in out Positive;
        Op_Abs : out Op_Code_Absolute;
        Relatif_Vers_Absolu : out Boolean)
    is
        Contenu : String := Avancer_Au_Separateur(Ligne_D, Curseur);
        Op : Op_Code;
    begin
        -- On avance au séparateur

        if Contenu'Length /= 1 then
            -- L'opcode est composé d'une seule lettre
            raise Courbe_Illisible with "Instruction SVG mal formée (longeur > 1): " & Contenu;
        end if;

        declare
            Last : Positive;

            -- https://www2.adacore.com/gap-static/GNAT_Book/html/aarm/AA-A-10-10.html
            package Op_Code_IO is new Enumeration_IO (Op_Code);
        begin
            -- On convertit la chaine en opcode
            -- On ajoute des quotes pour que le parser sache
            -- que c'est un enum caractère
            Op_Code_IO.Get("'" & Contenu & "'", Op, Last);
        exception
            when Data_Error =>
                -- Si opcode non supporté
                raise Courbe_Illisible with "Instruction SVG non supportée: " & Contenu & " " & Positive'Image(Contenu'Length);
        end;

        -- Si l'opcode est en minuscule (coord. relatives)
        -- On indique travailler en relatif
        Relatif_Vers_Absolu := Op in Op_Code_Relative;

        -- Et on le convertit en majuscule (coord. absolues)
        Op_Abs := Op_Code'Value(To_Upper (Op_Code'Image(Op)));
    end;

    function Point_Relatif (
        Point_Base : Point2D;
        Relatif_Vers_Absolu : Boolean)
        return Point2D
    is
    begin
        if Relatif_Vers_Absolu then
            return Point_Base;
        else
            return (others => 0.0);
        end if;
    end;
    
    procedure Gerer_OpCode (
        Ligne_D : String;
        Curseur : in out Positive;
        Position_Courante : in out Point2D;
        Op : Op_Code_Absolute;
        L : in out Liste;
        Relatif_Vers_Absolu : Boolean)
    is
        Point_Base : Point2D := (others => 0.0);
    begin
        Put_Line ("Gestion opcode" & Op_Code'Image(Op));
        if Relatif_Vers_Absolu and then Taille (L) /= 0  then
            Point_Base := Position_Courante;
        end if;

        case Op is
            when 'M' =>
                Lire_Point2D(Ligne_D, Curseur, Position_Courante);
                Position_Courante := Position_Courante + Point_Base;
            when 'L' =>
                declare
                    P : Point2D;
                begin
                    Lire_Point2D(Ligne_D, Curseur, P);
                    P := P + Point_Base;

                    Insertion_Queue (L, Position_Courante);
                    Insertion_Queue (L, P);
                end;
            when 'H' =>
                declare
                    P : Point2D := Point_Base;
                begin
                    P (1) := P (1) + Lire_Coord(Ligne_D, Curseur);

                    Insertion_Queue (L, Position_Courante);
                    Insertion_Queue (L, P);
                end;
            when 'V' =>
                declare
                    P : Point2D := Point_Base;
                begin
                    P (2) := P (2) + Lire_Coord(Ligne_D, Curseur);

                    Insertion_Queue (L, Position_Courante);
                    Insertion_Queue (L, P);
                end;
            when 'C' => 
                loop
                    declare
                        C1, C2, P : Point2D;
                    begin
                        Lire_Point2D(Ligne_D, Curseur, C1);
                        Lire_Point2D(Ligne_D, Curseur, C2);
                        Lire_Point2D(Ligne_D, Curseur, P);

                        C1 := C1 + Point_Base;
                        C2 := C2 + Point_Base;
                        P := P + Point_Base;

                        Bezier(Position_Courante, C1, C2, P, Nombre_Points, L);
                    end;

                    -- On look-ahead pour voir si on a encore un jeu de coordonnées
                    -- ou si on a on un opcode
                    declare
                        Fin_Curseur : Positive;
                        Contenu_Suivant : String := Voir_Au_Separateur (Ligne_D, Curseur, Fin_Curseur);
                    begin
                        -- On sort si on a un opcode ou plus rien
                        exit when Contenu_Suivant'Length <= 1;
                    end;
                end loop;
            when 'Q' =>
                declare
                    C, P : Point2D;
                begin
                    Lire_Point2D(Ligne_D, Curseur, C);
                    Lire_Point2D(Ligne_D, Curseur, P);

                    C := C + Point_Base;
                    P := P + Point_Base;

                    Bezier(Position_Courante, C, P, Nombre_Points, L);
                end;
        end case;

        -- Tous les opcodes dessinent en modifiant la liste
        -- sauf M, qui se contente de déplacer le point courant
        -- mais ne dessine rien
        -- On récupère donc la position courante pour tous les autres
        -- en regardant le dernier point ajouté par ceux-ci
        -- L'opcode M modifie directement la position courante
        if Op /= 'M' then
            Position_Courante := Queue (L);
        end if;
    end;

    procedure Chargement_Bezier(Nom_Fichier : String; L : out Liste) is
        -- on charge le fichier svg
        Ligne_D : String := Get_Ligne_D(Nom_Fichier);

        Curseur : Positive := Ligne_D'First;

        Position_Courante : Point2D := (others => 0.0);

        Op_Abs : Op_Code_Absolute;
        Relatif_Vers_Absolu : Boolean;
    begin
        -- analyse de cette même ligne en gérant
        -- les différents opcode (mlhvcq et MLHVCQ)

        -- Tant qu'on est pas à la fin de la ligne
        while Curseur <= Ligne_D'Last loop
            -- Lecture de l'opcode L,
            Lire_OpCode (Ligne_D, Curseur, Op_Abs, Relatif_Vers_Absolu);

            -- Traitement de l'opcode
            Gerer_OpCode (Ligne_D, Curseur, Position_Courante, Op_Abs, L, Relatif_Vers_Absolu);
        end loop;
    end;
end;
