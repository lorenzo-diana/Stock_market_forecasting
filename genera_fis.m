num_epoch=100;
fis = genfis1(Input_anfis_training, [3 3 3], 'pimf', 'linear');
[fis,error,stepsize,chkFis,chkErr] = anfis(Input_anfis_training, fis, [num_epoch NaN NaN NaN NaN], [NaN NaN NaN NaN], Input_anfis_checking, 1);
