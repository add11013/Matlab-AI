clear
clc
c=0;
a=1;
ca=[0 1];
x=linspace(c-5*a,c+5*a,100);
dimension=3;
r=gaussmf(x,ca,1);


for i=1:5
    figure(i)
    codefunction(r,x,ca,mod(i,3)+2,mod(i,9)+5,3);
end

figure(6)
for i=1:13
    subplot(4,4,i)
    y=gaussmf(x,ca,i);
    plot(x,y)
end
