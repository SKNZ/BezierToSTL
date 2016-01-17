with Ada.Text_IO; use Ada.Text_IO;
with Vecteurs; use Vecteurs;
with Courbes.Droites; use Courbes.Droites;
with Courbes.Singletons; use Courbes.Singletons;
with Courbes.Bezier_Cubiques; use Courbes.Bezier_Cubiques;
with Courbes.Bezier_Quadratiques; use Courbes.Bezier_Quadratiques;
with Helper; use Helper;

package body Parser_Svg is
    procedure Charger_SVG(Nom_Fichier : String; L : out Liste) is
        Iterateur : Iterateur_Mot;
    begin
        Put_Line("Lecture du fichier source " & Nom_Fichier);

        Debug("Recherche ligne figure (marqueur: " & Marqueur_Ligne & ")");
        declare
            -- Obtention de la ligne "d="
            Ligne_D : constant String :=
                Helper.Fichier_Ligne_Commence_Par(
                    Nom_Fichier,
                    Marqueur_Ligne);
        begin
            -- Si on a pas trouvé de ligne 
            if Ligne_D'Length = 0 then
                raise Courbe_Abs;
            end if;

            Debug("Figure trouvée");

            -- On instancie l'itérateur mot à mot
            Iterateur := Initialiser(Ligne_D, Separateur);
        end;

        Debug("Chargement figure");

        -- Tant qu'on est pas à la fin
        while not Fin(Iterateur) loop
            declare
                Op : Op_Code;
            begin
                -- Lecture d'un l'opcode
                Lire_OpCode (Iterateur, Op);

                -- Traitement de l'opcode
                Gerer_OpCode (Iterateur, Op, L);
            end;
        end loop;

        Debug("Figure chargée");
        Debug;
        Debug("||||||||||||||||||||||||||||||||||");
        Debug;
    end;

    procedure Gerer_OpCode (
        Iterateur : in out Iterateur_Mot;
        Op : Op_Code;
        L : in out Liste)
    is
        Offset_Relatif, Position_Courante : Point2D := (others => 0.0);

        Mode_Relatif : constant Boolean := Op in Op_Code_Relative;
    begin
        Debug ("==================================");
        Debug ("Gestion opcode " & Op_Code'Image(Op) & "; relatif=" & Boolean'Image(Mode_Relatif));

        -- Boucle de lecture d'arguments
        -- Tant qu'il y a des arguments pour l'opcode courant
        -- on continue
        loop
            if Taille (L) /= 0 then
                Position_Courante := Queue (L).Obtenir_Fin;
                Debug("Position courante:");
                Debug(To_String(Position_Courante));
            end if;

            if Mode_Relatif then
                -- Dernier point de la dernière entrée de la liste
                -- (position courante)
                Offset_Relatif := Position_Courante;
                Debug("Offset_Relatif = Position_Courante");
            else
                Debug("Offset_Relatif = 0");
            end if;

            case Op is
                when 'M' | 'm' =>
                    declare 
                        P : Point2D;
                    begin
                        Helper.Lire_Point2D(Iterateur, Separateur_Coord, P);
                        P := P + Offset_Relatif;

                        Insertion_Queue(L, new Singleton'(Ctor_Singleton(P)));
                    end;
                when 'L' | 'l' =>
                    declare
                        P : Point2D;
                    begin
                        Helper.Lire_Point2D(Iterateur, Separateur_Coord, P);
                        P := P + Offset_Relatif;

                        Insertion_Queue (L, new Droite'(Ctor_Droite(Position_Courante, P)));
                    end;
                when 'H' | 'h' =>
                    declare
                        P : Point2D := Offset_Relatif;
                    begin
                        P (P'First) := P (P'First) + Helper.Lire_Coord(Iterateur);

                        Insertion_Queue (L, new Droite'(Ctor_Droite(Position_Courante, P)));
                    end;
                when 'V' | 'v' =>
                    declare
                        P : Point2D := Offset_Relatif;
                    begin
                        P (P'Last) := P (P'Last) + Helper.Lire_Coord(Iterateur);

                        Insertion_Queue (L, new Droite'(Ctor_Droite(Position_Courante, P)));
                    end;
                when 'C' | 'c' => 
                    declare
                        C1, C2, P : Point2D;
                    begin
                        Helper.Lire_Point2D(Iterateur, Separateur_Coord, C1);
                        Helper.Lire_Point2D(Iterateur, Separateur_Coord, C2);
                        Helper.Lire_Point2D(Iterateur, Separateur_Coord, P);


                        C1 := C1 + Offset_Relatif;
                        C2 := C2 + Offset_Relatif;
                        P := P + Offset_Relatif;

                        Insertion_Queue (L, new Bezier_Cubique'(Ctor_Bezier_Cubique(Position_Courante, P, C1, C2)));
                    end;
                when 'Q' | 'q' =>
                    declare
                        C, P : Point2D;
                    begin
                        Helper.Lire_Point2D(Iterateur, Separateur_Coord, C);
                        Helper.Lire_Point2D(Iterateur, Separateur_Coord, P);

                        C := C + Offset_Relatif;
                        P := P + Offset_Relatif;

                        Insertion_Queue (L, new Bezier_Quadratique'(Ctor_Bezier_Quadratique(Position_Courante, P, C)));
                    end;
            end case;

            Debug("Recherche arguments supplémentaires");
            -- On look-ahead pour voir si on a encore des coordonnées
            -- si on a on un opcode
            exit when Mot_Suivant_Est_Op_Code_Ou_Vide (Iterateur);

            Debug("++++++++++++++++++++++++++++++++++");
            Debug("Arguments supplémentaires trouvés");
        end loop;
        Debug("Pas d'arguments en plus, rech. op code suivant");
    end;

    function Interpreter_Op_Code (Contenu : String; Op : in out Op_Code) return Boolean is
        Last : Positive;

        -- https://www2.adacore.com/gap-static/GNAT_Book/html/aarm/AA-A-10-10.html
        package Op_Code_IO is new Enumeration_IO (Op_Code);
    begin
        -- On convertit la chaine en opcode
        -- On ajoute des quotes pour que le parser sache
        -- que c'est un enum caractère
        Op_Code_IO.Get("'" & Contenu & "'", Op, Last);

        return true;
    exception
        when Data_Error =>
            -- Si opcode non supporté
            return false;
    end;

    procedure Lire_OpCode (Iterateur : in out Iterateur_Mot; Op : out Op_Code) is
        -- Obtient le mot suivant
        Contenu : constant String := Avancer_Mot_Suivant(Iterateur);
    begin
        if Contenu'Length /= 1 then
            -- L'opcode est composé d'une seule lettre
            raise Courbe_Illisible with "Instruction SVG mal formée (longeur > 1): " & Contenu;
        end if;

        if not Interpreter_Op_Code (Contenu, Op) then
            raise Courbe_Illisible with "Instruction SVG non supportée: " & Contenu & " " & Positive'Image(Contenu'Length);
        end if;
    end;

    function Mot_Suivant_Est_Op_Code_Ou_Vide (
        Iterateur : Iterateur_Mot)
        return Boolean
    is
        Op : Op_Code;

        -- Peek ahead sur la suite
        Contenu_Suivant : constant String := Lire_Mot_Suivant (Iterateur);
    begin
        -- On sort si plus rien
        if Contenu_Suivant'Length = 0 then
            return true;
        end if;

        -- On a potentiellement un OpCode, on vérifie
        -- Rappel : opcode = 1 caractère
        if Contenu_Suivant'Length = 1 then
            return Interpreter_Op_Code (Contenu_Suivant, Op);
        end if;

        return false;
    end;
end;
