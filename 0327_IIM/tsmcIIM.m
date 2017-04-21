clear
clc

dataprocess

 for i=1:size(data,2)
     for j=1:size(data,2)
         %H(Y)
         h_y=getEntropy(data(:,j));
         %H(Y(X+)) ConditionEntropy: 1 is Positive,2 is Negative
         h_yOfxP=ConditionEntropy(data,i,j,1);
         %H(Y(X-)) ConditionEntropy: 1 is Positive,2 is Negative
         h_yOfxN=ConditionEntropy(data,i,j,2);
         c=0;
         for ii=1:length(data(:,i))
             if data(ii,i)<0
                 c=c+1;
                 xN(c,1)=data(ii,i);
             else
                 c=c+1;
                 xP(c,1)=data(ii,i);
             end
         end
         xxx=data(:,i);
         pd=fitdist(xxx,'kernel');
         x=linspace(mean(xxx)-5*std(xxx),mean(xxx)+5*std(xxx),300);
         sample=pdf(pd,x);
         rat1=cdf(pd,0);
         rat2=1-rat1;
         if(i==j)
            %IIM(i,j)=(h_y-h_yOfxP)*rat2+(h_y-h_yOfxN)*rat1;            
            IIM(i,j)=0;
         else
            IIM(i,j)=(h_y-h_yOfxP)*rat2+(h_y-h_yOfxN)*rat1;
            %IIM(i,j)=((h_y-h_yOfxN)+(h_y-h_yOfxP))/2;
         end
     end
 end
 IIM
