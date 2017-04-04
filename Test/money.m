figure(1);
hold on
%t=fetch(yahoo,'^TWII','Close','1/1/2016','12/31/2016','d');
%t2017=fetch(yahoo,'^TWII','Close','1/1/2017','2/15/2017','d');
load trainning.csv
load testing.csv
testPoint=length(testing);
point=length(trainning);
allpoint=point+testPoint;
x=linspace(1,allpoint,allpoint);
y=[(trainning(:,2));(testing(:,2))];
yMean=mean(y);
yStd=std(y);
plot(x,y);