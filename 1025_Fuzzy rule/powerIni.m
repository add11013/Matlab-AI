z = linspace(100, 800, point_n);
power_fs = [350 80;
		 500 80;
		 650 80;
		 800 100];
for i = 1:4,
	power_mf(i, :) = gaussmf(z, power_fs(i, :));
end