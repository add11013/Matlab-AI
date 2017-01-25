figure(1);
hold on
point=100;
x=linspace(3,7,point);
for i=1:100
    y(i)=0.08*((1.2*(x(i)-1)*cos(3*x(i)))+(x(i)-(x(i)-1)*cos(3*x(i))*sin(x(i))));
end
yMean=mean(y);
yStd=std(y);
plot(x,y);
