with Courbes; use Courbes;
with Courbes.Singletons; use Courbes.Singletons;
with Courbes.Droites; use Courbes.Droites;
with Courbes.Bezier_Cubiques; use Courbes.Bezier_Cubiques;
with Courbes.Visiteurs; use Courbes.Visiteurs;
with Vecteurs; use Vecteurs;

package Interpolations_Lineaires is
    subtype Tolerance is Float range 0.01 .. 1.0;

    use Liste_Points;

    -- Interpole linéairement toutes les courbes d'une liste en N points
    -- Interpoler_Droites permet de désactiver l'interpolation des droites
    -- (l'interpolation est alors laissée à l'afficheur)
    procedure Interpolation_Lineaire(
        Courbes : Liste_Courbes.Liste;
        Segments : in out Liste;
        Nombre_Points : Positive;
        Interpoler_Droites : Boolean := False;
        Utiliser_DeCasteljau : Boolean := False;
        Tolerance_DeCasteljau : Tolerance := 0.5);

    private

    -- Generic parce que sinon pas possible de passer la liste
    generic
        -- Liste des segments générés
        Segments : in out Liste;

        -- Nombre de points à utiliser pour approcher la courbe
        Nombre_Points : Positive;

        -- Faut il interpoler la droite
        Interpoler_Droites : Boolean;

        -- Utiliser l'algo de Casteljau
        -- (Avantageux en terme de précision)
        Utiliser_DeCasteljau : Boolean;

        -- Tolérance si Casteljau 
        -- Détermine quand est-ce qu'une courbe
        -- peut être approchée par une droite
        Tolerance_DeCasteljau : Tolerance;
    package Visiteur_Interpolateur is
        type Interpolateur_Lineaire is new Visiteur_Courbe with null record;

        -- Cas général
        overriding procedure Visiter(Self : Interpolateur_Lineaire; C : Courbe);

        -- Cas particulier : droite
        overriding procedure Visiter(Self : Interpolateur_Lineaire; D : Droite);

        -- Cas particulier : bezier cubique (de casteljau) 
        overriding procedure Visiter(Self : Interpolateur_Lineaire; BC : Bezier_Cubique);

        -- Cas particulier : le singleton
        overriding procedure Visiter(Self : Interpolateur_Lineaire; S : Singleton);
    end Visiteur_Interpolateur;
end Interpolations_Lineaires;
