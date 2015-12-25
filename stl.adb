with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Numerics;
use Ada.Numerics;
with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;

package body STL is

    function Decaler(P : Point2D; Angle_Radian : Float) return Point3D is
    begin
        return (1 => P(P'First) * Cos(Angle_Radian),
                2 => P(P'Last),
                3 => P(P'First) * Sin(Angle_Radian));
    end;

    procedure Creation(Segments : in out Liste_Points.Liste ;
        Facettes : out Liste_Facettes.Liste) is
        Premier_Point : Point3D;
    begin
        -- L'idée est de parcourir l'axe y=0 pour CHAQUE angle
        -- et de créer des morceaux de "disques" à chaque fois
        -- C'est donc le pas qui varie en premier
        -- (plus facile de cette manière pour créer des triplets de points)
        for Pas in 1..M loop
            -- On crée d'abord le premier point décalé d'un angle 2*PI/Pas radian
            --Premier_Point := Decaler(Tete(Segments), (2.0 * PI)/Float(Pas));
            for I in 2..Liste_Points.Taille(Segments) loop
                null;
                -- TODO Créer une procedure de type Parcourir
                -- qui va créer deux facettes à chaque point créé.
                -- TODO Création des points sur le "disque"
                -- avec de la trigonométrie du swag.
                -- On crée un point, on crée 2 facettes !
                -- On insère deux Facettes (i.e. un groupe de 3 points) à chaque fois
            end loop;
        end loop;
    end;

    procedure Sauvegarder(Nom_Fichier : String ;
        Facettes : Liste_Facettes.Liste) is
    begin
        null;
    end;
end;
