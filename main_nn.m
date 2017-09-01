% progetto matlab
% creazione della amtrice dei campioni
output=xlsread('data_akbilgic.xlsx','C:C', '', 'basic');
Input(:, 1:7)=xlsread('data_akbilgic.xlsx','D:J', '', 'basic');

%num_training_nn=12;

% crea il vettore di output dei campioni da usare per l'allenamento
output_allenamento_nn=output(8:end);

% ciclo punto 1
mse_avg=100;
num_tr=[8 10 12];
for n=5:9
    for t=1:size(num_tr, 2)
        for z=1:5
            for  i=1:7
                % crea la matrice dei campioni di input
                Campioni_input_allenamento_nn=crea_matrice(Input(:, i));
                % crea e allena la rete
                script_nn
                mse_nn(i)=performance; % salva l'MSE
            end
            if ((sum(mse_nn)/7)<mse_avg)
                mse_avg=sum(mse_nn)/7;
                best_mse_nn=mse_nn;
                best_t=t;
                best_n=n;
            end
        end
    end
end
%for temp=1:5
%for i=1:7
%    disp(sprintf('%d, %d', temp, i));
    % crea la matrice dei campioni di input
%    Campioni_input_allenamento_nn=crea_matrice(Input(:, i));
    % crea la rete neurale e la allena num_training_nn volte, poi calcola il suo MSE
%    script_nn
%    mse_nn(i)=performance; % salva l'MSE per ogni indice da valutare
%end
%mse_nn
%end