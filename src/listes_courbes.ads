with Liste_Generique;
with Courbes; use Courbes;

package Listes_Courbes is
    package Liste_Courbes is new Liste_Generique(Courbe_Ptr);
end Listes_Courbes;
