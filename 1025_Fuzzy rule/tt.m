
point_n=100;
temperatureIni;
subplot(311);
temperaturePlot;

quantityIni;
subplot(312);
quantityPlot;

powerIni;
subplot(313);
powerPlot;


point_n  =15;
x = linspace(-20, 15, point_n);
y = linspace(1, 100, point_n);
output = zeros(point_n, point_n);

%% target
target=@(x) x.^2+1;

%% error caculation
rmse();

%% test
%ff(temp_fs,quantity_fs);



%% plot error
figure(3)
plot(z(1:100),t1,z(1:100),t2);
axis([-inf inf 0 1000 ])

%% 
figure(2)
mesh(x, y, output');
set(gca, 'box', 'on');
axis([-inf inf -inf inf -inf inf]);
xlabel('Temperature'); ylabel('Quantity'); zlabel('Power(w)');

