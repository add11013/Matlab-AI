figure(1);
%t=fetch(yahoo,'^GSPC','Close','1/1/2016','12/31/2016','d');
t=linspace(1,252,252);
point=length(t);
x=linspace(1,point,point);
%y=flipud(t(:,2));
for i=1:point 
    y(i,1)=t(1,i);
end
yMean=mean(y);
yStd=std(y);

plot(x,y);

pd=fitdist(y,'kernel');
sample=pdf(pd,y);
figure(2)
plot(x,sample);