package body Helper is
    procedure Interpolation_Lineaire_Gen(C : in out Courbe_Ptr) is
    begin
        C.Interpolation_Lineaire (Segments, Nombre_Points);
    end;
end Helper;
