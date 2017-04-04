figure(1);
hold on
%t=fetch(yahoo,'^GSPC','Close','1/1/2016','12/31/2016','d');
%t2017=fetch(yahoo,'^GSPC','Close','1/1/2017','2/9/2017','d');
load SP500
testPoint=length(t2017);
point=length(t);
allpoint=point+testPoint;
x=linspace(1,allpoint,allpoint);
y=[flipud(t(:,2));flipud(t2017(:,2))];
yMean=mean(y);
yStd=std(y);
plot(x,y);