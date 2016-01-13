with Ada.Numerics;
use Ada.Numerics;
with Vecteurs; use Vecteurs;

package STL is
    -- Pas de la rotation
    M : constant Natural := 50;

    -- Angle de la rotation en radian
    Angle_Radian : constant Float := (2.0 * PI)/Float(M);

    -- Prend une liste de segments et cree l'objet 3d par rotations
    -- Requiert Taille(Segments) > 0
    procedure Creation(Segments : in out Liste_Points.Liste ;
        Facettes : out Liste_Facettes.Liste);

    -- Sauvegarde le fichier stl
    procedure Sauvegarder(Nom_Fichier : String ;
        Facettes : Liste_Facettes.Liste);
end;