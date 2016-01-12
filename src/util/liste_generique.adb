with Ada.Unchecked_Deallocation;

package body Liste_Generique is

    procedure Liberer is new Ada.Unchecked_Deallocation(Cellule, Pointeur);

    procedure Vider(L : in out Liste) is
        Cour : Pointeur := L.Debut;
        Next : Pointeur;
    begin
        while Cour /= null loop
            Next := Cour.Suivant;
            Liberer(Cour);
            Cour := Next;
        end loop;
        -- La liste est réinitialisée
        L.Taille := 0;
        L.Debut := null;
        L.Fin := null;
    end;

    procedure Insertion_Tete(L : in out Liste ; E : Element) is
    begin
        if L.Debut = null then
            L.Debut := new Cellule'(Contenu => E, Suivant => null);
            L.Fin := L.Debut;
        else
            L.Debut := new Cellule'(Contenu => E, Suivant => L.Debut);
        end if;

        L.Taille := L.Taille + 1;
    end;

    procedure Insertion_Queue(L : in out Liste ; E : Element) is
        Ptr_Cellule : Pointeur;
    begin
        if L.Debut = null then
            L.Debut := new Cellule'(Contenu => E, Suivant => null);
            L.Fin := L.Debut;
        else
            Ptr_Cellule := new Cellule'(Contenu => E, Suivant => null);
            L.Fin.Suivant := Ptr_Cellule;
            L.Fin := Ptr_Cellule;
        end if;

        L.Taille := L.Taille + 1;
    end;

    procedure Parcourir (L : Liste) is
        Cour : Pointeur := L.Debut;
    begin
        while Cour /= null loop
            Traiter(Cour.Contenu);
            Cour := Cour.Suivant;
        end loop;
    end;

    procedure Parcourir_Par_Couples(L : Liste) is
        Cour : Pointeur := L.Debut;
    begin
        while Cour /= null loop
            if Cour.Suivant /= null then
                Traiter(Cour.Contenu, Cour.Suivant.Contenu);
            end if;
            Cour := Cour.Suivant;
        end loop;
    end;

    procedure Fusion(L1 : in out Liste ; L2 : in out Liste) is
    begin
        if L1.Taille /= 0 then
            L1.Fin.Suivant := L2.Debut;
        else
            L1.Debut := L2.Debut;
        end if;
        L1.Fin := L2.Fin;
        L1.Taille := L1.Taille + L2.Taille;
        L2.Debut := null;
        L2.Fin := null;
        L2.Taille := 0;
    end;

    function Taille(L : Liste) return Natural is
    begin
        return L.Taille;
    end;

    function Tete(L : Liste) return Element is
    begin
        return L.Debut.Contenu;
    end;

    function Queue(L : Liste) return Element is
    begin
        return L.Fin.Contenu;
    end;

end;
