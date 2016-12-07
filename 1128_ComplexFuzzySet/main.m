clear
clc

x=linspace(-10,10,1000);
ca=[0,2];
l=60;
u=ws(x,ca,l);


figure(1);
plot3(x,real(u),imag(u))
axis([-10 10 -1 1 -1 1]);
grid on

figure(2);
plot(x,gaussmf(x,ca),x,real(u),'--',x,imag(u),'--');

figure(3);
plot(real(u),imag(u))