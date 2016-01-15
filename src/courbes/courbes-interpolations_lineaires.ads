with Courbes.Singletons; use Courbes.Singletons;
with Courbes.Droites; use Courbes.Droites;
with Courbes.Visiteurs; use Courbes.Visiteurs;

package Courbes.Interpolations_Lineaires is
    use Liste_Points;

    -- Interpole linéairement toutes les courbes d'une liste en N points
    -- Interpoler_Droites permet de désactiver l'interpolation des droites
    -- (l'interpolation est alors laissée à l'afficheur)
    procedure Interpolation_Lineaire(
        Courbes : Liste_Courbes.Liste;
        Segments : in out Liste;
        Nombre_Points : Positive;
        Interpoler_Droites : Boolean := False);

    -- Interpole linéairement une courbe en N points
    -- Interpoler_Droites permet de désactiver l'interpolation des droites
    -- (l'interpolation est alors laissée à l'afficheur)
    procedure Interpolation_Lineaire(
        C : Courbe_Ptr;
        Segments : in out Liste;
        Nombre_Points : Positive;
        Interpoler_Droites : Boolean := False);

private
    -- Generic parce que sinon pas possible de passer la liste
    generic
        Segments : in out Liste;
        Nombre_Points : Positive;
        Interpoler_Droites : Boolean;
    package Visiteur_Interpolateur is
        type Interpolateur_Lineaire is new Visiteur_Courbe with null record;

        -- Cas général
        overriding procedure Visiter(Self : Interpolateur_Lineaire; C : Courbe);

        -- Cas particulier : la droite
        overriding procedure Visiter(Self : Interpolateur_Lineaire; D : Droite);

        -- Cas particulier : le singleton
        overriding procedure Visiter(Self : Interpolateur_Lineaire; S : Singleton);
    end Visiteur_Interpolateur;
end Courbes.Interpolations_Lineaires;
