function Matrix=crea_matrice(input_)
	for i=1:(size(input_, 1)-7) % ci fermiamo prima 536-6 (-7 perchè mancherebbe l'ultimo valore dell'ise100
		Matrix(i, :)=input_(i:i+6)'; % l'ultima riga andrà da 530 a 536 compresi
    end
end
