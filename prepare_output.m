function ou=prepare_output(o)
	for e=1:size(o, 1)
        if (o(e)>0) % se rispetto al giorno precedente siamo saliti
            ou(e)=1; % allora 1
        else
            ou(e)=2; % se siamo scesi allora 0
        end
    end
end