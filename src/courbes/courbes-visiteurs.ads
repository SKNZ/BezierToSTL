with Courbes.Singletons; use Courbes.Singletons;
with Courbes.Droites; use Courbes.Droites;
with Courbes.Bezier_Cubiques; use Courbes.Bezier_Cubiques;
with Courbes.Bezier_Quadratiques; use Courbes.Bezier_Quadratiques;

package Courbes.Visiteurs is
    type Visiteur_Courbe is abstract tagged limited null record;

    procedure Visiter(Self : Visiteur_Courbe; C : Courbe);
    procedure Visiter(Self : Visiteur_Courbe; D : Droite);
    procedure Visiter(Self : Visiteur_Courbe; S : Singleton);
    procedure Visiter(Self : Visiteur_Courbe; BC : Bezier_Cubique);
    procedure Visiter(Self : Visiteur_Courbe; BQ : Bezier_Quadratique);
end Courbes.Visiteurs;
