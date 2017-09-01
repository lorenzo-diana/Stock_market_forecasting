indici_scelti_nn=[1 2 4 5]; % l' indice 4 si potrebbe anche togliere, 1 e 5 sono i migliori
%preparazione input e output per anfisedit

%input presi in sequenza. training da 1 a 402, testing da 403 a 402+67,
%checking da 470 a 469+67
%lim_training=floor(size(Input, 1)*75/100);
%lim_testing=lim_training+floor( (size(Input, 1)-(lim_training)) /2);
%Input_anfis_training=[Input(1:lim_training, indici_scelti_nn), output(1:lim_training)];
%Input_anfis_testing=[Input(lim_training+1:lim_testing, indici_scelti_nn), output(lim_training+1:lim_testing)];
%Input_anfis_checking=[Input(lim_testing+1:end, indici_scelti_nn), output(lim_testing+1:end)];

%input presi in modo sparso a intervalli regolari
%x=1:8:536;
x=1:6.7:536;
x=round(x);
targets_ISE=prepare_output(output(x));
Input_anfis_testing=Input(x, indici_scelti_nn);
Input_anfis_checking=[Input((x+3), indici_scelti_nn), prepare_output(output(x+3))'];
Input_anfis_training=[Input(:, indici_scelti_nn), prepare_output(output)'];
Input_anfis_training([x x+3], :)=[];

num_epoch=30;

fun=['trimf' 'psigmf' 'gbellmf' 'gaussmf' 'gauss2mf' 'pimf' 'dsigmf' 'trapmf']; % migliori 3 4 e 5
fun_supp=[1 5 6 11 12 18 19 25 26 33 34 37 38 43 44 49];
o_fun=['linear' 'constant']; % migliore lineare
o_fun_supp=[1 6 7 14];

for o=1:2:4;
    for f=1:2:16;
        for a=0:1
            %creare il fis, allenarlo e salvarlo nel workspace
            fis = genfis1(Input_anfis_training, 3, fun(fun_supp(f):fun_supp(f+1)), o_fun(o_fun_supp(o):o_fun_supp(o+1)));
            [fis,error,stepsize,chkFis,chkErr] = anfis(Input_anfis_training, fis, [num_epoch NaN NaN NaN NaN], [NaN NaN NaN NaN], Input_anfis_checking, a);

            % valutazioni performance
            out=evalfis(Input_anfis_testing, chkFis);
            out=out';
            giorni_correttamente_predetti=my_round(out)==targets_ISE;
            if (a==0)
                PCFD_b(o, f)=(sum(giorni_correttamente_predetti)/size(targets_ISE, 2))*100;
                MSE_b(o, f)=sum( (targets_ISE-my_round(out)).*(targets_ISE-my_round(out)) )/size(targets_ISE, 2);
                MAPE_fis_b(o, f)=sum( abs( ((targets_ISE-my_round(out))./targets_ISE).*100 ) )/size(targets_ISE, 2);
            else
                PCFD_h(o, f)=(sum(giorni_correttamente_predetti)/size(targets_ISE, 2))*100;
                MSE_h(o, f)=sum( (targets_ISE-my_round(out)).*(targets_ISE-my_round(out)) )/size(targets_ISE, 2);
                MAPE_fis_h(o, f)=sum( abs( ((targets_ISE-my_round(out))./targets_ISE).*100 ) )/size(targets_ISE, 2);
            end
        end
    end
end
%PCFD_b(:, [2 4 6 8 10 12 14])=[];
%PCFD_b(2, :)=[];
%MSE_b(:, [2 4 6 8 10 12 14])=[];
%MSE_b(2, :)=[];
%MAPE_fis_b(:, [2 4 6 8 10 12 14])=[];
%MAPE_fis_b(2, :)=[];
%PCFD_h(:, [2 4 6 8 10 12 14])=[];
%PCFD_h(2, :)=[];
%MSE_h(:, [2 4 6 8 10 12 14])=[];
%MSE_h(2, :)=[];
%MAPE_fis_h(:, [2 4 6 8 10 12 14])=[];
%MAPE_fis_h(2, :)=[];

%for o=1:2:4;
%for f=1:2:16;
%    o
%    f
    
% creare il fis, allenarlo e salvarlo nel workspace
%fis = genfis1(Input_anfis_training, 3, fun(fun_supp(f):fun_supp(f+1)), o_fun(o_fun_supp(o):o_fun_supp(o+1)));
%fis = genfis1(Input_anfis_training, 3, 'trapmf', 'linear');
%    for z=1:4
%[fis,error,stepsize,chkFis,chkErr] = anfis(Input_anfis_training, fis, [num_epoch NaN NaN NaN NaN], [NaN NaN NaN NaN], Input_anfis_checking, 1);
%    z
%    end

% valutazioni performance
%out=evalfis(Input_anfis_testing, chkFis);
%out=out';
%giorni_correttamente_predetti=round(out)==targets_ISE;
%PCFD(o, f)=(sum(giorni_correttamente_predetti)/size(targets_ISE, 2))*100;
%performance_fis(o, f) = perform(rete,tonndata(output_previsto_ga',false,false),outputs_forecast); % MSE
%MAPE_fis(o, f)=sum( abs( ((targets_ISE-round(out))./targets_ISE).*100 ) )/size(targets_ISE, 2);
%end
%end