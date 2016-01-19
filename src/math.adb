with Ada.Numerics.Generic_Elementary_Functions;

package body Math is
    package Float_Elementary_Functions is new Ada.Numerics.Generic_Elementary_Functions (Float);
    use Float_Elementary_Functions;

    function Hypot(P : Point2D) return Float is
        X : constant Float := abs P(P'First);
        Y : constant Float := abs P(P'Last);
        Min_Coord : constant Float := Float'Min(X, Y);
        Max_Coord : constant Float := Float'Max(X, Y);
        Ratio : constant Float := Min_Coord / Max_Coord;
    begin
        return Max_Coord * Sqrt (1.0 + Ratio ** 2);
    end;
end;
