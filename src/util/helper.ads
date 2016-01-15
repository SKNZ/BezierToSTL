with Courbes; use Courbes;
with Vecteurs; use Vecteurs;

package Helper is
    -- Pour rendre plus élégante l'utilisation avec parcourir
    -- On fournit une version générique de discretiser
    -- qui accepte une liste de segments et un nb de pts
    -- en paramètres génériques
    generic
        Segments : in out Liste_Points.Liste;
        Nombre_Points : Positive;
    procedure Interpolation_Lineaire_Bind_2nd_3rd(C : in out Courbe_Ptr);
end Helper;
