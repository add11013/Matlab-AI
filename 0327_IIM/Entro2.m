function output = Entro2(data,f1,f2)
%ENTRO2 Summary of this function goes here
%   Detailed explanation goes here


    %y(x+)
     c=0;
     for i=1:length(data)
         if data(i,f1)>0
             c=c+1;
             xP(c,1)=data(i,f1);
             xP_yIndex(c)=i;
         end
     end
     for i=1:c
         yOfxP(i,1)=data(xP_yIndex(i),f2);
     end
     %H(X+)
     y=data(:,f1);
     r_y=linspace(mean(y)-5*std(y),mean(y)+5*std(y),300);
     ry=r_y(2)-r_y(1);
     x=data(:,f2);
     r_x=linspace(mean(x)-5*std(x),mean(x)+5*std(x),300);
     rx=r_x(2)-r_x(1);
     output=sum(getPdf(xP).*sum(getPdf(yOfxP).*log(1./getPdf(yOfxP)).*ry).*rx);
end

