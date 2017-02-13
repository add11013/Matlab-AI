figure(1);
hold on
%t=fetch(yahoo,'S&P500','Close','1/1/2016','12/31/2016','d');
%t2017=fetch(yahoo,'S&P500','Close','1/1/2017','2/9/2017','d');
load SP
testPoint=length(t2017);
point=length(t);
allpoint=point+testPoint;
x=linspace(1,allpoint,allpoint);
y=[t(:,2);t2017(:,2)];
yMean=mean(y);
yStd=std(y);
plot(x,y);