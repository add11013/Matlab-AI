figure(1);
hold on
%t=fetch(yahoo,'TAIEX','Close','1/1/2016','31/12/2016','m');
load test
point=length(t);
x=linspace(1,point,point);
y=t(:,2);
yMean=mean(y);
yStd=std(y);
plot(x,y);
