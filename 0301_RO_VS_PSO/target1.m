figure(1);
hold on
point=100;
x=linspace(-2,2,point);
for i=1:100
    y(i,1)=x(i).^2+10;
end
yStd=std(y);
yMean=mean(y);
plot(x,y);
