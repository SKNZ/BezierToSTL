with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Strings; use Ada.Strings;

package body Helper is
    function Fichier_Ligne_Commence_Par(Nom_Fichier, Marqueur : String)
        return String
    is
        Cible : Unbounded_String := Null_Unbounded_String;
        Fichier : Ada.Text_IO.File_Type;
    begin
        -- On ouvre le fichier
        Ada.Text_IO.Open (Fichier, Ada.Text_IO.In_File, Nom_Fichier);

        -- On s'arrête qd la ligne est trouvée ou à la fin du fichier
        while Length(Cible) = 0
            and then not Ada.Text_IO.End_Of_File (Fichier) loop
            declare
                -- On obtient une ligne, et on enlève les espaces en début/fin
                Ligne : constant String :=
                    Trim (Ada.Text_IO.Get_Line (Fichier), Both);
            begin
                -- on récupère la ligne commençant par "d="
                if Ligne'Length >= Marqueur'Length
                    and then Ligne (Marqueur'Range) = Marqueur then
                    Cible := To_Unbounded_String (Ligne (Ligne'First + Marqueur'Length .. Ligne'Last - 1));
                end if;
            end;
        end loop;

        -- Fermeture du fichier
        Ada.Text_IO.Close (Fichier);

        return To_String (Cible);
    end;

    procedure Lire_Point2D(
        Iterateur : in out Iterateur_Mot;
        Separateur_Coord : Character;
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
                raise Erreur_Lecture with "Manque deuxième coordonnée";
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
                    raise Erreur_Lecture with "Nombre flottant mal formé";
            end;
        end;

        -- On sauvergarde le point qu'on a trouvé
        Point := (Point'First => X, Point'Last => Y);        
        Put_Line("Arg" & To_String (Point));
    end;

    function Lire_Coord(Iterateur : in out Iterateur_Mot) return Float is
        -- Obtient le mot suivant
        Contenu : constant String := Avancer_Mot_Suivant(Iterateur);
    begin
        -- On transforme le contenu en flottant
        return Float'Value (Contenu);
    exception
        when Constraint_Error =>
            -- Si les nombres sont mal formés...
            raise Erreur_Lecture with "Flottant mal formé";
    end;

    procedure Afficher_Debug(Afficher : Boolean) is
    begin
        Etat_Debug := Afficher;
    end;

    procedure Debug(Chaine : String) is
    begin
        if Etat_Debug then
            Put_Line(Chaine);
        end if;
    end;

    procedure Debug is
    begin
        if Etat_Debug then
            New_Line;
        end if;
    end;
end Helper;
