with Courbes.Singletons; use Courbes.Singletons;
with Courbes.Visiteurs; use Courbes.Visiteurs;

package Courbes.Interpolations_Lineaires is
    use Liste_Points;

    -- Interpole linéairement une courbe en N points
    procedure Interpolation_Lineaire(C : Courbe_Ptr; Segments : in out Liste; Nombre_Points : Positive);

private
    -- Generic parce que sinon pas possible de passer la liste
    generic
        Segments : in out Liste;
        Nombre_Points : Positive;
    package Visiteur_Interpolateur is
        type Interpolateur_Lineaire is new Visiteur_Courbe with null record;

        -- Cas général
        overriding procedure Visiter(Self : Interpolateur_Lineaire; C : Courbe);

        -- Cas particulier : le singleton
        overriding procedure Visiter(Self : Interpolateur_Lineaire; S : Singleton);
    end Visiteur_Interpolateur;
end Courbes.Interpolations_Lineaires;
