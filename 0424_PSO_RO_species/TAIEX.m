figure(1);
hold on
%t=fetch(yahoo,'^TWII','Close','1/2/2003','2/27/2006','d');
%t2017=fetch(yahoo,'^TWII','Close','1/1/2017','2/15/2017','d');
A=csvread('Training.csv')
load TAIEX
testPoint=length(t2017);
point=length(t);
allpoint=point+testPoint;
x=linspace(1,allpoint,allpoint);
y=[flipud(t(:,2));flipud(t2017(:,2))];
yMean=mean(y);
yStd=std(y);
plot(x,y);