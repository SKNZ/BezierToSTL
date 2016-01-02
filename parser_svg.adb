with Ada.Text_IO, Ada.Float_Text_IO, Ada.Characters.Handling;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Characters.Handling;

package body Parser_Svg is
	procedure Get_Ligne_D(Nom_Fichier : String; Ligne_D : out String) is
		Fichier : Ada.Text_IO.File_Type;
	begin
		Ligne_D := "";
		Ada.Text_IO.Open (Fichier, Ada.Text_IO.In_File, Nom_Fichier);
		while Ligne_D'Length = 0 and then not Ada.Text_IO.End_Of_File (Fichier) loop
			declare
				Ligne : String := Ada.Text_IO.Get_Line (Fichier);
			begin
				-- on récupère la ligne commençant par "d="
				if Ligne'Length >= Marqueur_Ligne'Length and then Ligne (Marqueur_Ligne'First .. Marqueur_Ligne'First + Marqueur_Ligne'Length) = Marqueur_Ligne then
					Ligne_D := Ligne;
				end if;
			end;
		end loop;
		Ada.Text_IO.Close (Fichier);
	end;

    procedure Move_To(Point : Point2D; L : in out Liste) is
    begin
        null;
    end;

    procedure Line_To(Point : Point2D; L : in out Liste) is
    begin
        null;
    end;

    procedure Horizontal_Line_To(X : Float; L : in out Liste) is
    begin
        null;
    end;

    procedure Vertical_Line_To(Y : Float; L : in out Liste) is
    begin
        null;
    end;

    procedure Curve_To(C1, C2, P : Point2D; L : in out Liste) is
    begin
        null;
    end;

    procedure Quadratic_Curve_To(C, P : Point2D; L : in out Liste) is
    begin
        null;
    end;

    procedure Avancer_Separateur(Ligne_D : String; Position : in out Integer) is
    begin
        if Ligne_D (Position + 1) /= Separateur
        then
            raise Courbe_Illisible;
        end if;

        Position := Position + 1;
    end;

    procedure Lire_Point2D(Ligne_D : String; I : Integer; Point : out Point2D) is
    begin
        null;
    end;

    procedure Lire_Ligne_D(Ligne_D : String; L : out Liste) is
        I : Integer := Ligne_D'First;
        Op_Code : Character;
    begin
        while I <= Ligne_D'Last loop
            Op_Code := Ligne_D (I);

            case Op_Code is
                when 'M' =>
                    null;
                when 'L' =>
                    null;
                when 'H' =>
                    null;
                when 'V' =>
                    null;
                when 'C' => 
                    null;
                when 'Q' =>
                    null;
                when others =>
                    raise Courbe_Illisible;
            end case;
        end loop;
    end;

	procedure Chargement_Bezier(Nom_Fichier : String; L : out Liste) is
		Ligne_D : String := "";
	begin
		-- on charge le fichier svg
		Get_Ligne_D(Nom_Fichier, Ligne_D);

		if Ligne_D'Length = 0 then
			raise Courbe_Abs;
		end if;

		-- Troisième étape : analyse de cette même ligne en gérant
		-- les différents cas (mlhvcq et MLHVCQ) + enregistrement des segments
		-- dans une liste chainée
		-- Quatrième étape : conversion des points en courbe de Bézier
		-- (enregistrement dans L)
		-- Cinquième étape : Profit
		null;
	end;

end;
