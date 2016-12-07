y = linspace(1, 100, point_n);
quantity_fs = [30 15;
		85 20];
for i = 1:2,
	quantity_mf(i, :) = gaussmf(y, quantity_fs(i, :));
end