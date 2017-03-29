clear
clc
load data.csv

%H(Y)
target_h=Entro(data(:,2));
%H(Y(X+))
y_XP=Entro2(data,1,2);
