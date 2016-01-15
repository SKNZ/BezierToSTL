with Courbes.Interpolations_Lineaires; use Courbes.Interpolations_Lineaires;

package body Helper is
    procedure Interpolation_Lineaire_Bind_2nd_3rd(C : in out Courbe_Ptr) is
    begin
        Interpolation_Lineaire (C.all, Segments, Nombre_Points);
    end;
end Helper;
