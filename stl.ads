-- TODO Prétraitement : décalage de xmin et ymin
with Liste_Generique;
with Math; use Math;

package STL is
    -- Pas de la rotation
    M : constant Positive := 30;

    subtype Point3D is Vecteur(1..3);

    type Facette is record
        P1, P2, P3 : Point3D;
    end record;

    package Liste_Facettes is new Liste_Generique(Facette);

    --prend une liste de segments et cree l'objet 3d par rotations
    -- Requiert Taille(Segments) > 0
    procedure Creation(Segments : in out Liste_Points.Liste ;
        Facettes : out Liste_Facettes.Liste);

    --sauvegarde le fichier stl
    procedure Sauvegarder(Nom_Fichier : String ;
        Facettes : Liste_Facettes.Liste);

private
    -- Crée un point 3D à partir d'un point 2D et d'un angle de rotation
    -- Requiert un angle en radian
    function Decaler(P : Point2D; Angle_Radian : Float) return Point3D;
end;
