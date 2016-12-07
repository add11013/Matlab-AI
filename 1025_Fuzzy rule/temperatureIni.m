%point_n=100;
x = linspace(-20, 15, point_n);
temp_fs = [10 5;
		-15 5];
for i = 1:2,
	temp_mf(i,:) = gaussmf(x, temp_fs(i,:));
end