function [i] = computei2( data,locx,locy)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
[aa,bb,cc]=selectdata2(data,locx,locy,1);
    [yy1,xx1]=sampling(aa);
    [yy2,xx2]=sampling(bb);
    [yy3,xx3]=sampling(cc);
    y1y3=[yy1 yy3];
    maxdelta=max(max(y1y3+1e-300),1);
    alfa1 = hy(yy1,xx1,maxdelta);
    beta1 = hxy(yy2,xx2,yy3,xx3,maxdelta);
    if(locx==locy)
        beta1=alfa1;
    else
        beta1 = hxy(yy2,xx2,yy3,xx3,maxdelta);
    end

[aa,bb,cc]=selectdata2(data,locx,locy,2);
    [yy1,xx1]=sampling(aa);
    [yy2,xx2]=sampling(bb);
    [yy3,xx3]=sampling(cc);
    y1y3=[yy1 yy3];
    maxdelta=max(max(y1y3+1e-300),1);
    alfa2 = hy(yy1,xx1,maxdelta);
    beta2 = hxy(yy2,xx2,yy3,xx3,maxdelta);
    if(locx==locy)
        beta2=alfa2;
    else
        beta2 = hxy(yy2,xx2,yy3,xx3,maxdelta);
    end
    if(alfa2<0)
        disp('error');
    elseif(beta2<0)
        disp('error');
    else
    end
%i2=hy(yy1,xx1,maxdelta)-hxy(yy2,xx2,yy3,xx3,maxdelta);

pd=fitdist(bb,'kernel');
x=linspace(pd.mean-pd.std*5,pd.mean+pd.std*5,300);
rat1=cdf(pd,0);rat2=1-rat1;
%[rat1,rat2]=computerate(bb);
%i=(alfa1-beta1)*rat2+(alfa2-beta2)*rat1;
i=((alfa1-beta1)+(alfa2-beta2))/2;
%i=alfa1-(beta1*rat2+beta2*rat1);

end

