with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Strings; use Ada.Strings;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Text_IO; use Ada.Text_IO;
with Courbes.Droites; use Courbes.Droites;
with Courbes.Singletons; use Courbes.Singletons;
with Courbes.Bezier_Cubiques; use Courbes.Bezier_Cubiques;
with Courbes.Bezier_Quadratiques; use Courbes.Bezier_Quadratiques;

package body Parser_Svg is
    procedure Charger_SVG(Nom_Fichier : String; L : out Liste) is
        -- on charge le fichier svg
        Ligne_D : constant String := Trouver_Ligne_D(Nom_Fichier);

        Position_Courante : Point2D := (others => 0.0);

        Op_Abs : Op_Code_Absolute;
        Relatif_Vers_Absolu : Boolean;

        Iterateur : Iterateur_Mot;
    begin
        -- On instancie l'itérateur
        Initialiser_String(
            Chaine => To_Unbounded_String(Ligne_D),
            Curseur => Ligne_D'First,
            Separateur => Separateur,
            Iterateur => Iterateur);

        Put_Line("Lecture de la courbe");
        -- analyse de cette même ligne en gérant
        -- les différents opcode (mlhvcq et MLHVCQ)

        -- Tant qu'on est pas à la fin de la ligne
        while Iterateur.Curseur <= Ligne_D'Last loop
            -- Lecture de l'opcode L,
            Lire_OpCode (Iterateur, Op_Abs, Relatif_Vers_Absolu);

            -- Traitement de l'opcode
            Gerer_OpCode (Iterateur, Position_Courante, Op_Abs, L, Relatif_Vers_Absolu);
        end loop;
    end;

    function Trouver_Ligne_D(
        Nom_Fichier : String)
        return String
    is
        Ligne_D : Unbounded_String := Null_Unbounded_String;
        Fichier : Ada.Text_IO.File_Type;
    begin
        Put_Line("Recherche de la courbe dans le fichier " & Nom_Fichier);
        -- On ouvre le fichier
        Ada.Text_IO.Open (Fichier, Ada.Text_IO.In_File, Nom_Fichier);

        -- On s'arrête qd la ligne est trouvée ou à la fin du fichier
        while Length(Ligne_D) = 0
            and then not Ada.Text_IO.End_Of_File (Fichier) loop
            declare
                -- On obtient une ligne, et on enlève les espaces en début/fin
                Ligne : constant String := Trim (Ada.Text_IO.Get_Line (Fichier), Both);
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

        Put_Line("Courbe trouvée");
        return To_String (Ligne_D);
    end;

    procedure Lire_Point2D(
        Iterateur : in out Iterateur_Mot;
        Point : out Point2D)
    is
        Contenu : constant String := Avancer_Mot_Suivant(Iterateur);

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
            -- et il manque donc une information
            if Separateur_Curseur = Contenu'Last 
                or else Separateur_Curseur = Contenu'First then
                raise Courbe_Illisible with "Manque deuxième coordonnée";
            end if;

            declare
                -- On récupère la première coordonnée
                X_Text : constant String := Contenu (Contenu'First .. Separateur_Curseur - 1);
                -- On récupère la deuxième coordonnée
                Y_Text : constant String := Contenu (Separateur_Curseur + 1 .. Contenu'Last);
            begin
                -- Conversion des coordonnées text vers flottant
                X := Float'Value (X_Text);
                Y := Float'Value (Y_Text);
            exception
                when Constraint_Error =>
                    -- Si les nombres sont mal formés...
                    raise Courbe_Illisible with "Nombre flottant mal formé";
            end;
        end;

        -- On sauvergarde le point qu'on a trouvé
        Point := (Point'First => X, Point'Last => Y);        
        Put_Line("Arg" & To_String (Point));
    end;

    function Lire_Coord(
        Iterateur : in out Iterateur_Mot)
        return Float
    is
        -- Obtient le mot suivant
        Contenu : constant String := Avancer_Mot_Suivant(Iterateur);
    begin
        -- On transforme le contenu en flottant
        return Float'Value (Contenu);
    exception
        when Constraint_Error =>
            -- Si les nombres sont mal formés...
            raise Courbe_Illisible with "Flottant mal formé";
    end;

    procedure Lire_OpCode (
        Iterateur : in out Iterateur_Mot;
        Op_Abs : out Op_Code_Absolute;
        Relatif_Vers_Absolu : out Boolean)
    is
        -- Obtient le mot suivant
        Contenu : constant String := Avancer_Mot_Suivant(Iterateur);
        -- L'opcode qu'on va lire
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

    function Mot_Suivant_Est_Op_Code_Ou_Vide (
        Iterateur : Iterateur_Mot)
        return Boolean
    is
        Fin_Curseur : Positive;
        Contenu_Suivant : constant String := Lire_Mot_Suivant (Iterateur, Fin_Curseur);
    begin
        -- On sort si plus rien
        if Contenu_Suivant'Length = 0 then
            return true;
        end if;

        -- On a potentiellement un OpCode, on vérifie
        -- Rappel : opcode = 1 caractère
        if Contenu_Suivant'Length = 1 then
            declare
                -- Inutile
                Last : Positive;

                -- OpCode extrait, inutile
                Op : Op_Code;

                -- https://www2.adacore.com/gap-static/GNAT_Book/html/aarm/AA-A-10-10.html
                package Op_Code_IO is new Enumeration_IO (Op_Code);
            begin
                -- On convertit la chaine en opcode
                -- On ajoute des quotes pour que le parser sache
                -- que c'est un enum caractère
                Op_Code_IO.Get("'" & Contenu_Suivant & "'", Op, Last);

                -- Si la lecture n'a pas planté
                -- On indique avoir trouvé un opcode
                return true;
            exception
                when Data_Error =>
                    -- On a une erreur, donc ce n'est pas un opcode
                    -- On continue la boucle si ce n'est pas un opcode
                    null; -- False est renvoyé à la fin 
            end;
        end if;

        -- Le mot n'est pas un opcode
        -- (cf bloc exception ci dessus)
        return false;
    end;

    procedure Gerer_OpCode (
        Iterateur : in out Iterateur_Mot;
        Position_Courante : in out Point2D;
        Op : Op_Code_Absolute;
        L : in out Liste;
        Relatif_Vers_Absolu : Boolean)
    is
        Offset_Relatif : Point2D := (others => 0.0);
    begin
        Put_Line ("==================================");
        Put_Line ("Gestion opcode " & Op_Code'Image(Op) & "; relatif=" & Boolean'Image(Relatif_Vers_Absolu));
        
        -- Boucle de lecture d'arguments
        -- Tant qu'il y a des arguments pour l'opcode courant
        -- on continue
        loop
            if Relatif_Vers_Absolu then
                Offset_Relatif := Position_Courante;
            end if;

            Put_Line("Offset Relatif    " & To_String (Offset_Relatif));

            case Op is
                when 'M' =>
                    Lire_Point2D(Iterateur, Position_Courante);
                    Position_Courante := Position_Courante + Offset_Relatif;

                    Insertion_Queue(L, Ctor_Singleton(Position_Courante));
                when 'L' =>
                    declare
                        P : Point2D;
                    begin
                        Lire_Point2D(Iterateur, P);
                        P := P + Offset_Relatif;

                        Insertion_Queue (L, Ctor_Droite(Position_Courante, P));
                    end;
                when 'H' =>
                    declare
                        P : Point2D := Offset_Relatif;
                    begin
                        P (P'First) := P (P'First) + Lire_Coord(Iterateur);

                        Insertion_Queue (L, Ctor_Droite(Position_Courante, P));
                    end;
                when 'V' =>
                    declare
                        P : Point2D := Offset_Relatif;
                    begin
                        P (P'Last) := P (P'Last) + Lire_Coord(Iterateur);

                        Insertion_Queue (L, Ctor_Droite(Position_Courante, P));
                    end;
                when 'C' => 
                    declare
                        C1, C2, P : Point2D;
                    begin
                        Lire_Point2D(Iterateur, C1);
                        Lire_Point2D(Iterateur, C2);
                        Lire_Point2D(Iterateur, P);
                        

                        C1 := C1 + Offset_Relatif;
                        C2 := C2 + Offset_Relatif;
                        P := P + Offset_Relatif;

                        Insertion_Queue (L, Ctor_Bezier_Cubique(Position_Courante, P, C1, C2));
                    end;
                when 'Q' =>
                    declare
                        C, P : Point2D;
                    begin
                        Lire_Point2D(Iterateur, C);
                        Lire_Point2D(Iterateur, P);

                        C := C + Offset_Relatif;
                        P := P + Offset_Relatif;

                        Insertion_Queue (L, Courbe_Ptr(Ctor_Bezier_Quadratique(Position_Courante, P, C)));
                    end;
            end case;

            -- Tous les opcodes modifient la liste
            -- sauf M, qui se contente de déplacer le point courant
            -- mais ne dessine rien
            -- On récupère donc la position courante pour tous les autres
            -- en regardant le dernier point ajouté par ceux-ci
            -- L'opcode M modifie directement la position courante
            if Op /= 'M' then
                Position_Courante := Queue (L).Obtenir_Fin;
            end if;

            Put_Line("Pos       " & To_String (Position_Courante));

            -- On look-ahead pour voir si on a encore des coordonnées
            -- si on a on un opcode
            exit when Mot_Suivant_Est_Op_Code_Ou_Vide (Iterateur);

            Put_Line("||||||||||||||||||||||||||||||||||");
            Put_Line("Arguments supplémentaires trouvés.");
        end loop;
    end;
end;
