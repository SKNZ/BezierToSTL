with Ada.Text_Io;
use Ada.Text_Io;

package body Math is
    -- Procedure test
    -- Affiche un Point2D
    procedure Display(P : in out Point2D) is
    begin
        Put(Float'Image(P(P'First)));
        Put(Float'Image(P(P'Last)));
        New_Line;
    end;

    function "+" (A : Vecteur ; B : Vecteur) return Vecteur is
        R : Vecteur(A'Range);
    begin
        for I in R'Range loop
            -- B n'a pas a priori le même indiçage que A
            R(I) := A(I) + B(B'First - A'First + I);
        end loop;
        return R;
    end;

    function "*" (Facteur : Float ; V : Vecteur) return Vecteur is
        R : Vecteur(V'Range);
    begin
        for I in R'Range loop
            R(I) := Facteur * V(I);
        end loop;
        return R;
    end;
    
    function Bezier_Quad(P1, C, P2 : Point2D; X : Float) return Point2D is
    begin
        return (1.0 - X) * (1.0 - X) * P1
               + 2.0 * X * (1.0 - X) * C
               + X * X * P2; 
    end;

    function Bezier_Cub(P1, C1, C2, P2 : Point2D; X : Float) return Point2D is
    begin
        return (1.0 - X) * (1.0 - X) * (1.0 - X) * P1
               + 3.0 * X * (1.0 - X) * (1.0 - X) * C1
               + 3.0 * X * X * (1.0 - X) * C2
               + X * X * X * P2; 
    end;

    procedure Bezier(P1, C1, C2, P2 : Point2D ; Nb_Points : Positive ;
        Points : out Liste) is
    begin
        -- La courbe commence en P1
        Insertion_Queue(Points, P1);

        -- Variation de 0 à 1 d'où le reverse
        for N in reverse 1 .. Nb_Points loop
            Insertion_Queue(Points, Bezier_Cub(P1, C1, C2, P2, 1.0/Float(N)));
        end loop;
        -- Remarque : on atteint bien P2 lorsque N = 1
    end;

    procedure Bezier(P1, C, P2 : Point2D ; Nb_Points : Positive ;
        Points : out Liste) is
    begin
        -- La courbe commence en P1
        Insertion_Queue(Points, P1);

        -- Variation de 0 à 1 d'où le reverse
        for N in reverse 1 .. Nb_Points loop
            Insertion_Queue(Points, Bezier_Quad(P1, C, P2, 1.0/Float(N)));
        end loop;
        -- Remarque : on atteint bien P2 lorsque N = 1
    end;
end;
