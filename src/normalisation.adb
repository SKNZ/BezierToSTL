with Helper; use Helper;

package body Normalisation is
    -- Centre la figure sur l'axe X
    -- Raccorde les extremités de la figure à l'axe
    procedure Normaliser(Segments : in out Liste) is
        Coords_Min : constant Point2D := Trouver_Coords_Min (Segments);
        
        procedure Normaliser_Point(P : in out Point2D) is
        begin
            P := P - Coords_Min;
        end;
        
        procedure Normaliser_Liste is new Parcourir(Normaliser_Point);

        Debut : Point2D;
        Fin : Point2D;
    begin
        Debug("Offset appliqué:");
        Debug(To_String(Coords_Min));
        Normaliser_Liste(Segments);

        -- Instanciation maintenant car Segments a été décalé
        Debut := Tete(Segments);
        Fin := Queue(Segments);

        -- Points à rajouter en début et fin de courbe
        Debut := (Debut'First => Debut(Debut'First), Debut'Last => 0.0);
        Fin := (Fin'First => Fin(Fin'First), Fin'Last => 0.0);

        -- On vérifie leur utilité 
        if Debut /= Tete(Segments) then
            Debug("Rajout d'un raccord en début de figure");
            Insertion_Tete(Segments, Debut);
        end if;

        if Fin /= Queue(Segments) then
            Debug("Rajout d'un raccord en fin de figure");
            Insertion_Queue(Segments, Fin);
        end if;

        Debug("Fin normalisation");
        Debug;
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
