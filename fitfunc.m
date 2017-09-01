function PCFD_ts = fitfunc(delay)
    in_d=delay(1);
    feed_d=delay(2);
    num_neu=delay(3);
    
    % crea la rete e la allena num_training_ga volte
    script_ts

    % calcola i giorni correttamente predetti
    giorni_correttamente_predetti=my_round(cell2mat(outputs))==my_round(cell2mat(targets));
    PCFD_ts=(sum(giorni_correttamente_predetti)/size(cell2mat(targets), 2))*100;
    PCFD_ts=100-PCFD_ts;
end
