-- TODO Prétraitement : décalage de xmin et ymin
with Liste_Generique;
with Math; use Math;
with Ada.Numerics;
use Ada.Numerics;
with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;

package STL is
    -- Pas de la rotation
    M : constant Positive := 30;

    -- Angle de la rotation en radian
    Angle_Radian : constant Float := (2.0 * PI)/Float(M);

    subtype Point3D is Vecteur(1..3);

    type Facette is record
        P1, P2, P3 : Point3D;
    end record;

    package Liste_Facettes is new Liste_Generique(Facette);

    -- Prend une liste de segments et cree l'objet 3d par rotations
    -- Requiert Taille(Segments) > 0
    procedure Creation(Segments : in out Liste_Points.Liste ;
        Facettes : out Liste_Facettes.Liste);

    -- Sauvegarde le fichier stl
    procedure Sauvegarder(Nom_Fichier : String ;
        Facettes : Liste_Facettes.Liste);
end;
