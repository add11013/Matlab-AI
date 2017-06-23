clear
clc
c=0;
a=1;
ca=[0 1];
x=linspace(c-5*a,c+5*a,100);

figure(1)
for i=2:13
    subplot(4,3,i-1)
    plot(x,gaussmf(x,ca,i));
end

figure(2)
hold on
for i=1:13
    plot(x,gaussmf(x,ca,i));
end
legend('y','dy/dx','dy/dc','dy/da','d2y/dx2','d2y/dxdc','d2y/dxda','d2y/dcdx','d2y/dc2','d2y/dcda','d2y/dadx','d2y/dadc','d2y/da2');