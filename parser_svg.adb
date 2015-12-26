with Ada.Text_IO, Ada.Float_Text_IO;
use Ada.Text_IO, Ada.Float_Text_IO;

package body Parser_Svg is

    procedure Chargement_Bezier(Nom_Fichier : String; L : out Liste) is
    begin
        -- Première étape : on charge le fichier svg
        -- Deuxième étape : on récupère la ligne commençant par "d="
        -- Troisième étape : analyse de cette même ligne en gérant
        -- les différents cas (mlhvcq et MLHVCQ) + enregistrement des segments
        -- dans une liste chainée
        -- Quatrième étape : conversion des points en courbe de Bézier
        -- (enregistrement dans L)
        -- Cinquième étape : Profit
        null;
    end;

end;
