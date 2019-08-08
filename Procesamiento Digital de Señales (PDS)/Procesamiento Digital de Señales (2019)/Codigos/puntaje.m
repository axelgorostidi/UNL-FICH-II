function error = puntaje(pitch_bueno,pitch_grabado)
M = length(pitch_bueno);
N = length(pitch_grabado);
cant_tonos = 7;
porc_tramo = 0.3;
tam_tramo = floor(M/cant_tonos);
error = [];
    if (M==N)
        for i=0:cant_tonos-1
            tramo_bueno = pitch_bueno(floor(tam_tramo*i+tam_tramo*porc_tramo):floor(tam_tramo*(i+1)-tam_tramo*porc_tramo));
            tramo_grabado = pitch_grabado(floor(tam_tramo*i+tam_tramo*porc_tramo):floor(tam_tramo*(i+1)-tam_tramo*porc_tramo));

            m = floor(length(tramo_bueno));
            n = floor(length(tramo_grabado));
            err = [];
    %         if (m==n)
                for j=1:n
                    tb = tramo_bueno(j);
                    tg = tramo_grabado(j);
                    if isnan(tb)
                        tb = 0;
                    end;
                    if isnan(tg)
                        tg = 0;
                    end;
                    e = abs(tb-tg);
                    err=[err e];
                end
                
                
                for j=1:length(err)
                    if (err(j)==0)
                        err(j) = 10000;
                    end;
                end
                minimo=min(err);
                
                error_medio = mean2(err);
                error = [error error_medio]
    %         else disp('Los tramos de se�ales deben tener la misma cantidad de muestras');
    %         end
        end
    else disp('Las se�ales deben tener la misma cantidad de muestras');
    end
end