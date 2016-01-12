with Ada.Text_Io;
use Ada.Text_Io;

package body Math is
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
        Points : in out Liste) is
    begin
        for N in 0..Nb_Points loop
            Insertion_Queue(Points, Bezier_Cub(P1, C1, C2, P2, Float(N)/Float(Nb_Points)));
            --Put_Line("BeC" & To_String(Queue(Points)));
        end loop;
        -- Remarque : la courbe commence bien en P1 pour N=0
        --            et finit bien en P2 pour N=Nb_Points
    end;

    procedure Bezier(P1, C, P2 : Point2D ; Nb_Points : Positive ;
        Points : in out Liste) is
    begin
        for N in 0..Nb_Points loop
            Insertion_Queue(Points, Bezier_Quad(P1, C, P2, Float(N)/Float(Nb_Points)));
            --Put_Line("BeQ" & To_String(Queue(Points)));
        end loop;
        -- Remarque : la courbe commence bien en P1 pour N=0
        --            et finit bien en P2 pour N=Nb_Points
    end;
end;
