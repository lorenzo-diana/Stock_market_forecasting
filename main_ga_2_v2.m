best_delay=[9 8]; % 87.5% giorni corretti nel train
% punto 2 b
retrain_net=1; % se = 1, si riallena la rete dopo ogni previsione
num_retraining_ga=5;
max_delay=max(best_delay);
in_d=best_delay(1);
feed_d=best_delay(2);

%script_ts % crea la rete con i ritardi migliori trovati al punto precedente

oriz_lim=40;
performance_forecast=zeros(1, oriz_lim)-1;
MAPE_forecast_ts=zeros(1, oriz_lim)-1;
PCFD_forecast_ts=zeros(1, oriz_lim)-1;

for orizzonte=1:oriz_lim;
    if (retrain_net==1)
        script_ts
    end
    input_nuovo_allenamento=Input_alenamento_ga;
    output_nuovo_allenamento=output_allenamento_ga;
    Input_previsto_ga_2=[Input_alenamento_ga((end-max_delay-orizzonte+2):end, :); Input_previsto_ga];
    output_previsto_ga_2=[output_allenamento_ga(:, (end-max_delay-orizzonte+2):end) output_previsto_ga];
    outputs_forecast=cell(0);
    for pos=max_delay+1:(max_delay+size(output_previsto_ga, 2));
        rete=closeloop(net);
        inputSeries = tonndata(Input_previsto_ga_2((pos-max_delay):(pos+orizzonte-1), :),false,false);
        targetSeries = tonndata([output_previsto_ga_2((pos-max_delay):(pos-1)) nan(1, orizzonte)]',false,false);
        [inputs_forecast,inputStates,layerStates,targets_forecast] = preparets(rete,inputSeries,{},targetSeries);
        out_rete = rete(inputs_forecast,inputStates,layerStates);
        outputs_forecast = [outputs_forecast out_rete(end)];
        %targets_originali = [targets_originali targets_forecast];
        
        % rialleniamo la rete
        if (retrain_net==1)
            input_nuovo_allenamento=[input_nuovo_allenamento; Input_previsto_ga(pos-max_delay, :)];
            output_nuovo_allenamento=[output_nuovo_allenamento output_previsto_ga(pos-max_delay)];
            inputSeries = tonndata(input_nuovo_allenamento,false,false);
            targetSeries = tonndata(output_nuovo_allenamento',false,false);
            [inputs,inputStates,layerStates,targets] = preparets(net,inputSeries,{},targetSeries);
            for q=1:num_retraining_ga
                [net,tr] = train(net,inputs,targets,inputStates,layerStates);
            end
        end
    end
    %targets_originali=output_previsto_ga;
    %targets_originali_cell=tonndata(targets_originali',false,false);
    % calcolo delle varie performances
    performance_forecast(orizzonte) = sum( (output_previsto_ga-my_round(cell2mat(outputs_forecast))).*(output_previsto_ga-my_round(cell2mat(outputs_forecast))) )/size(output_previsto_ga, 2);
    MAPE_forecast_ts(orizzonte)=sum( abs( ((output_previsto_ga-my_round(cell2mat(outputs_forecast)))./output_previsto_ga).*100 ) )/size(output_previsto_ga, 2);
    % calcola i giorni correttamente predetti
    giorni_correttamente_predetti=my_round(cell2mat(outputs_forecast))==output_previsto_ga;
    PCFD_forecast_ts(orizzonte)=(sum(giorni_correttamente_predetti)/size(output_previsto_ga, 2))*100;
end
%PCFD_9_8_siRet_4_neu=PCFD_forecast_ts;
%MAPE_9_8_siRet_4_neu=MAPE_forecast_ts;
%MSE_9_8_siRet_4_neu=performance_forecast;
%sum(sum(PCFD_forecast_ts))/40
%plot(1:40, PCFD_9_8_noRet_4_neu, 'b', 1:40, PCFD_13_10_noRet_5_neu, 'g', 1:40, PCFD_16_9_noRet_6_neu, 'c', 1:40, PCFD_20_14_noRet_7_neu, 'r', 1:40, PCFD_18_20_noRet_7_neu, 'y')
