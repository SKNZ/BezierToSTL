with Math;
use Math;

package body Normalisation is
    -- Centre la figure sur l'axe X
    -- Raccorde les extremités de la figure à l'axe
    procedure Normaliser(Segments : in out Liste) is
        Coords_Min : Point2D := Trouver_Coords_Min (Segments);
        
        procedure Normaliser_Point(P : in out Point2D) is
        begin
            P := P - Coords_Min;
        end;
        
        procedure Normaliser_Liste is new Parcourir(Normaliser_Point);

        Debut : Point2D := Tete(Segments);
        Fin : Point2D := Queue(Segments);
    begin
        Normaliser_Liste(Segments);

        Debut := (Debut'First => 0.0, Debut'Last => Debut(Debut'Last));
        Fin := (Fin'First => 0.0, Fin'Last => Fin(Fin'Last));

        -- On vérifie ne pas déjà être en 0
        if Debut /= Tete(Segments) then
            Insertion_Tete(Segments, Debut);
        end if;

        if Fin /= Queue(Segments) then
            Insertion_Queue(Segments, Fin);
        end if;
    end;

    -- Trouve les coord min
    function Trouver_Coords_Min(Segments : in out Liste) return Point2D is
        -- Abscisses et ordonnées minimales nécessaires
        -- pour le pré-traitement
        X_Min : Float := Tete(Segments)(Point2D'First);
        Y_Min : Float := Tete(Segments)(Point2D'Last);

        -- Met à jour les minima X_Min et Y_Min
        procedure Comparer_Min(P : in out Point2D) is
        begin
            -- On compare X_Min et l'abscisse du point P
            X_Min := Float'Min(X_Min, P(P'First));

            -- On compare Y_Min et l'ordonnée du point P
            Y_Min := Float'Min(Y_Min, P(P'Last));
        end;

        procedure Chercher_Min is new Parcourir(Comparer_Min);
    begin
        Chercher_Min (Segments);

        return (Point2D'First => X_Min, Point2D'Last => Y_Min);
    end;
end;
