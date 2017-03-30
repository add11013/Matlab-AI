function [i] = computei( data,locx,locy)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
[aa,bb,cc]=selectdata2(data,locx,locy,1);
    [yy1,xx1]=sampling(aa);[yy2,xx2]=sampling(bb);[yy3,xx3]=sampling(cc);y2y3=[yy2 yy3];
    maxdelta=max(y2y3);
    alfa1 = hy(yy2,xx2,maxdelta);
    beta1 = hxy(yy1,xx1,yy3,xx3,maxdelta);
    if(alfa1<0)
        disp('error');
    elseif(beta1<0)
        disp('error');
    else
    end
i1=hy(yy2,xx2,maxdelta)-hxy(yy1,xx1,yy3,xx3,maxdelta);;

[aa,bb,cc]=selectdata2(data,locx,locy,2);
    [yy2,xx2]=sampling(bb);[yy3,xx3]=sampling(cc);y2y3=[yy2 yy3];
    maxdelta=max(y2y3);
    alfa2 = hy(yy2,xx2,maxdelta);
    beta2 = hxy(yy1,xx1,yy3,xx3,maxdelta);
    if(alfa2<0)
        disp('error');
    elseif(beta2<0)
        disp('error');
    else
    end
i2=hy(yy2,xx2,maxdelta)-hxy(yy1,xx1,yy3,xx3,maxdelta);;

[aa,bb,cc]=selectdata(data,locx,locy,3);
    [yy2,xx2]=sampling(bb);[yy3,xx3]=sampling(cc);y2y3=[yy2 yy3];
    maxdelta=max(y2y3);
    alfa3 = hy(yy2,xx2,maxdelta);
    beta3 = hxy(yy1,xx1,yy3,xx3,maxdelta);
    if(alfa3<0)
        disp('error');
    elseif(beta3<0)
        disp('error');
    else
    end 
i3=hy(yy2,xx2,maxdelta)-hxy(yy1,xx1,yy3,xx3,maxdelta);;

[aa,bb,cc]=selectdata(data,locx,locy,4);
    [yy2,xx2]=sampling(bb);[yy3,xx3]=sampling(cc);y2y3=[yy2 yy3];
    maxdelta=max(y2y3);
    alfa4 = hy(yy2,xx2,maxdelta);
    beta4 = hxy(yy1,xx1,yy3,xx3,maxdelta);
    if(alfa4<0)
        disp('error');
    elseif(beta4<0)
        disp('error');
    else
    end
i4=hy(yy2,xx2,maxdelta)-hxy(yy1,xx1,yy3,xx3,maxdelta);;

i=(i1+i2+i3+i4)/4;
end

