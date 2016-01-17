with Vecteurs; use Vecteurs;

package STL is
    -- Prend une liste de segments et cree l'objet 3d par rotations
    -- Requiert Taille(Segments) > 0
    procedure Creation(
        Segments : in out Liste_Points.Liste ;
        Facettes : out Liste_Facettes.Liste;
        Nombre_Facettes : Positive);

    -- Sauvegarde le fichier stl
    procedure Sauvegarder(
        Nom_Fichier : String ;
        Facettes : Liste_Facettes.Liste);
end;
