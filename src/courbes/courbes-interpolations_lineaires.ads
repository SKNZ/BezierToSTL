with Courbes.Singletons; use Courbes.Singletons;
with Courbes.Visiteurs; use Courbes.Visiteurs;

package Courbes.Interpolations_Lineaires is
    use Liste_Points;

    -- Interpole linéairement une courbe en N points
    procedure Interpolation_Lineaire(C : Courbe; Segments : in out Liste_Points.Liste; Nombre_Points : Positive);

private
    type Interpolateur_Lineaire is new Visiteur_Courbe with
        record
            Segments : access Liste_Points.Liste;
            Nombre_Points : Integer;
        end record;

    -- Cas général
    overriding procedure Visiter(Self : Interpolateur_Lineaire; C : Courbe);

    -- Cas particulier : le singleton
    overriding procedure Visiter(Self : Interpolateur_Lineaire; S : Singleton);
end Courbes.Interpolations_Lineaires;
