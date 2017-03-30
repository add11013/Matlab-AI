function output = ConditionEntropy(data,f1,f2,NorP)
    %ConditionEntropy: H(f1->f2)
    %NorP:1 is Positive,2 is Negative
    
    %y(x+)
    if NorP==1
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
         y=data(:,f2);
         r_y=linspace(mean(y)-5*std(y),mean(y)+5*std(y),300);
         ry=r_y(2)-r_y(1);
         r_x=linspace(mean(xP)-5*std(xP),mean(xP)+5*std(xP),300);
         rx=r_x(2)-r_x(1);
         output=sum(getPdf(xP).*rx.*sum(getPdf(yOfxP).*log(1./getPdf(yOfxP)))).*ry;
    end
    %y(x-)
    if NorP==2
         c=0;
         for i=1:length(data)
             if data(i,f1)<0
                 c=c+1;
                 xN(c,1)=data(i,f1);
                 xN_yIndex(c)=i;     
             end
         end
         for ii=1:c
             yOfxN(ii,1)=data(xN_yIndex(ii),f2);
         end
         %H(X+)
         y=data(:,f2);
         r_y=linspace(mean(y)-5*std(y),mean(y)+5*std(y),300);
         ry=r_y(2)-r_y(1);
         r_x=linspace(mean(xN)-5*std(xN),mean(xN)+5*std(xN),300);
         rx=r_x(2)-r_x(1);
         output=sum(getPdf(xN).*rx.*sum(getPdf(yOfxN).*log(1./getPdf(yOfxN)))).*ry;
    end
end

