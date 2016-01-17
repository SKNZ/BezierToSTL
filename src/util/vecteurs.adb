package body Vecteurs is
    function To_String (P : Point2D) return String is
    begin
        return "(X => " & Float'Image(P (1)) & "; Y => " & Float'Image(P (2)) & ")";
    end;

    function To_String_3D (P : Point3D) return String is
    begin
        return "(X => " & Float'Image(P (1)) & "; Y => " & Float'Image(P (2)) & "; Z => " & Float'Image(P (3)) & ")";
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

    function "-" (A : Vecteur ; B : Vecteur) return Vecteur is
        R : Vecteur(A'Range);
    begin
        for I in R'Range loop
            -- B n'a pas a priori le même indiçage que A
            R(I) := A(I) - B(B'First - A'First + I);
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

    -- expo scalaire vecteur
    function "**" (V : Vecteur; Facteur : Positive) return Vecteur is
        R : Vecteur(V'Range);
    begin
        for I in R'Range loop
            R(I) := V(I) ** Facteur;
        end loop;
        return R;
    end;

    function "/" (V : Vecteur; Facteur : Float) return Vecteur is
        R : Vecteur(V'Range);
    begin
        for I in R'Range loop
            R(I) := V(I) / Facteur;
        end loop;
        return R;
    end;
    
end Vecteurs;
