figure(1);
hold on
point=276;
x=linspace(1,point,point);
t=fetch(yahoo,'TAIEX','Close','1/1/2016','31/12/2016','m');
y=t(:,2);
plot(x,y);
