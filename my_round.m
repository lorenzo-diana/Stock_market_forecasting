function my_r = my_round(vet)
    for i=1:max(size(vet))
        if (vet(i)>=1.5)
            my_r(i)=2;
        else
            my_r=1;
        end
    end
end