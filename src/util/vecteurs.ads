with Liste_Generique;

package Vecteurs is
    type Vecteur is array(Positive range<>) of Float;
    subtype Point2D is Vecteur(1..2);
    subtype Point3D is Vecteur(1..3);

    package Liste_Points is new Liste_Generique(Point2D);

    type Facette is record
        P1, P2, P3 : Point3D;
    end record;

    package Liste_Facettes is new Liste_Generique(Facette);

    -- addition de 2 vecteurs
    -- Requiert A, B de taille identique
    function "+" (A : Vecteur ; B : Vecteur) return Vecteur;

    -- soustraction de 2 vecteurs
    -- Requiert A, B de taille identique
    function "-" (A : Vecteur ; B : Vecteur) return Vecteur;

    -- multiplication scalaire vecteur
    function "*" (Facteur : Float ; V : Vecteur) return Vecteur;

    -- expo scalaire vecteur
    function "**" (V : Vecteur; Facteur : Positive) return Vecteur;

    -- division scalaire vecteur
    function "/" (V : Vecteur; Facteur : Float) return Vecteur;

    -- Renvoie une réprésentation chainée d'un point
    function To_String (P : Point2D) return String;
    function To_String_3D (P : Point3D) return String;
end Vecteurs;
