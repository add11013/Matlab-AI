clear,clc
figure(1);
%t=fetch(yahoo,'^GSPC','Close','1/1/2016','12/31/2016','d');
load data.csv
t=data(:,5);
%t=linspace(1,252,252);
point=length(t);
%y=flipud(t(:,2));
for i=1:point
    %y(i,1)=t(i,2);
    y(i,1)=t(i,1);
end
yMean=mean(y);
yStd=std(y);

x=linspace(yMean-5*yStd,yMean+5*yStd,point);
plot(x,y);

pd=fitdist(y,'kernel');

figure(2)
sample=pdf(pd,x);
plot(x,sample);
%range
for i=1:point
    p(i)=-sample(i)*log2(sample(i));
end
P=sum(p)


