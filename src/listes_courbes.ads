with Liste_Generique;
with Courbes; use Courbes;

package Listes_Courbes is
    type Courbe_Ptr is access all Courbe'Class;
    package Liste_Courbes is new Liste_Generique(Courbe_Ptr);
end Listes_Courbes;
