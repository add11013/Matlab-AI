figure(1);
hold on
x=linspace(-2,2);
for i=1:100
    y(i)=x(i).^2+10;
end
plot(x,y);