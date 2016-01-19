with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Directories;
with Helper; use Helper;
with Courbes; use Courbes;
with Courbes.Droites; use Courbes.Droites;
with Courbes.Singletons; use Courbes.Singletons;
with Courbes.Bezier_Cubiques; use Courbes.Bezier_Cubiques;
with Courbes.Bezier_Quadratiques; use Courbes.Bezier_Quadratiques;
with Interpolations_Lineaires; use Interpolations_Lineaires;
with Vecteurs; use Vecteurs;

-- Certains bonnes pratiques ont été sacrifiées
-- pour rendre les TU plus courts/simples
procedure test_unitaires is
    -- Activation des assert
    pragma Assertion_Policy(Check);

    LF : constant Character := Ada.Characters.Latin_1.LF;
    procedure Fichier_Ecrire_Chaine(F : String; S : String) is
        Handle : File_Type;
    begin
        begin
            Open(File => Handle, Mode => Out_File, Name => F);
        exception
            when Name_Error =>
                Create(File => Handle, Mode => Out_File, Name => F);
        end;

        Put_Line(Handle, S);

        Close(Handle);
    end;

    procedure Test_Trouver_Ligne_Fichier is
    begin
        Fichier_Ecrire_Chaine("tu.tmp",
            "aze" & LF &
            "rty" & LF & 
            "salut" & LF &
            "ca va""" & LF &
            "coucou");

        declare
            Str : constant String
                := Fichier_Ligne_Commence_Par("tu.tmp", "ca");
        begin
            pragma Assert (Str = " va");
        end;

        Ada.Directories.Delete_File ("tu.tmp");
        Debug("OK recherche ligne fichier");
    end;

    procedure Test_Singleton is
        P : constant Point2D := (1 => 1.0, 2 => 2.0);

        S : Courbe_Ptr := new Singleton'(Ctor_Singleton(P));
    begin
        pragma Assert (S.Obtenir_Debut = P, "S mauvais debut");
        pragma Assert (S.Obtenir_Fin = P, "S mauvais fin");
        pragma Assert (S.Obtenir_Point(0.0) = P, "S point 0.0 /= P");
        pragma Assert (S.Obtenir_Point(1.0) = P, "S point 1.0 /= P");
        pragma Assert (S.Obtenir_Point(0.5) = P, "S point 0.5 /= P"); 

        Liberer_Courbe(S);
        pragma Assert (S = null, "S deallocated ptr /= null");

        Debug("OK singleton");
    end;

    procedure Test_Droite is
        Deb : constant Point2D := (1 => 1.0, 2 => 2.0);
        Fin : constant Point2D := (1 => 3.0, 2 => 4.0);
        Mid : constant Point2D := (Deb + Fin) / 2.0;

        D : Courbe_Ptr := new Droite'(Ctor_Droite(Deb, Fin));
    begin
        pragma Assert (D.Obtenir_Debut = Deb, "BC mauvais debut");
        pragma Assert (D.Obtenir_Fin = Fin, "BC mauvais fin");
        pragma Assert (D.Obtenir_Point(0.0) = Deb, "BC point 0.0 /= debut");
        pragma Assert (D.Obtenir_Point(1.0) = Fin, "BC point 1.0 /= fin");
        pragma Assert (D.Obtenir_Point(0.5) = Mid, "BC point 0.5 /= mid"); 

        Liberer_Courbe(D);
        pragma Assert (D = null, "D deallocated ptr /= null");

        Debug("OK droite");
    end;

    procedure Test_Cubique is
        Deb : constant Point2D := (1 => 0.0, 2 => 0.0);
        Fin : constant Point2D := (1 => 2.0, 2 => 2.0);
        C1 : constant Point2D := (1 => 1.5, 2 => 0.5);
        C2 : constant Point2D := (1 => 0.5, 2 => 1.5);

        Mid : constant Point2D := (others => 1.0);

        BC : Courbe_Ptr := new Bezier_Cubique'(Ctor_Bezier_Cubique(Deb, Fin, C1, C2));
    begin
        pragma Assert (BC.Obtenir_Debut = Deb, "BC mauvais debut");
        pragma Assert (BC.Obtenir_Fin = Fin, "BC fin");
        pragma Assert (BC.Obtenir_Point(0.0) = Deb, "BC point 0.0 /= debut");
        pragma Assert (BC.Obtenir_Point(1.0) = Fin, "BC point 1.0 /= fin");
        pragma Assert (BC.Obtenir_Point(0.5) = Mid, "BC point 0.5 /= mid"); 

        Liberer_Courbe(BC);
        pragma Assert (BC = null, "BC deallocated ptr /= null");

        Debug("OK Bezier Cubique");
    end;

    procedure Test_Quadratique is
        Deb : constant Point2D := (1 => 0.0, 2 => 0.0);
        Fin : constant Point2D := (1 => 10.0, 2 => 0.0);
        C : constant Point2D := (1 => 5.0, 2 => 10.0);

        Mid : constant Point2D := (others => 5.0);

        BQ : Courbe_Ptr := new Bezier_Quadratique'(Ctor_Bezier_Quadratique(Deb, Fin, C));
    begin
        pragma Assert (BQ.Obtenir_Debut = Deb, "BQ mauvais debut");
        pragma Assert (BQ.Obtenir_Fin = Fin, "BQ fin");
        pragma Assert (BQ.Obtenir_Point(0.0) = Deb, "BQ point 0.0 /= debut");
        pragma Assert (BQ.Obtenir_Point(1.0) = Fin, "BQ point 1.0 /= fin");
        pragma Assert (BQ.Obtenir_Point(0.5) = Mid, "BQ point 0.5 /= mid"); 

        Liberer_Courbe(BQ);
        pragma Assert (BQ = null, "BQ deallocated ptr /= null");

        Debug("OK Bezier Quadratique");
    end;

    procedure Test_Interpolation_Lineaire is
        L : Liste_Courbes.Liste;
        S : Liste_Points.Liste;

        Deb : constant Point2D := (1 => 0.0, 2 => 0.0);
        Fin : constant Point2D := (1 => 2.0, 2 => 2.0);
        D : Courbe_Ptr := new Droite'(Ctor_Droite(Deb, Fin));

        I : Integer := 0;
        
        procedure Verif_Helper (P : in out Point2D) is
            Diff : constant Point2D := P - float(I) / 10.0 * Fin;
        begin
            pragma Assert(Diff(1) < 0.001, "Point invalide");
            pragma Assert(Diff(2) < 0.001, "Point invalide");
            I := I + 1;
        end;
        procedure Verif is new Liste_Points.Parcourir(Verif_Helper);
    begin
        Liste_Courbes.Insertion_Queue(L, D);

        Interpolation_Lineaire(L, S, 10, True);
        pragma Assert (Liste_Points.Taille(S) = 10, "Nb segments invalide");
        Verif(S);

        Liberer_Courbe(D);
        Liste_Courbes.Vider(L);
        Liste_Points.Vider(S);
        Debug("OK Interpolation");
    end;

begin
    Afficher_Debug(True);

    Test_Trouver_Ligne_Fichier;
    Test_Singleton;
    Test_Droite;
    Test_Cubique;
    Test_Quadratique;
    Test_Interpolation_Lineaire;
end;

