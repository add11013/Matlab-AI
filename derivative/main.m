close all
clear 
clc
c=0;
a=1;
ca=[0 1];
x=linspace(c-5*a,c+5*a,100);


for i=2:10
    figure(1)
    subplot(3,3,i-1);
    y=gaussmf(x,ca,i);
    plot(x,y);
end

figure(2)
hold on
for i=1:10
    y=gaussmf(x,ca,i);
    plot(x,y);
end
legend('y','dy/dx','dy/dx2','dy/dx3','dy/dc1','dy/dc2','dy/dc3','dy/ds1','dy/ds2','dy/ds3');


