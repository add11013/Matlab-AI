clear
clc

dataprocess
%data=textread('file1.txt');

 for i=1:size(data,2)
     for j=1:size(data,2)
         %H(Y)
         
         %H(Y(X+)) ConditionEntropy: 1 is Positive,2 is Negative
         [h_yP,h_yOfxP]=ConditionEntropy(data,i,j,1);
         %H(Y(X-)) ConditionEntropy: 1 is Positive,2 is Negative
         [h_yN,h_yOfxN]=ConditionEntropy(data,i,j,2);
         
         xxx=data(:,i);
         pd=fitdist(xxx,'kernel');
         rat1=cdf(pd,0);
         rat2=1-rat1;
         if(i==j)
            %IIM(i,j)=(h_yP-h_yOfxP)*rat2+(h_yN-h_yOfxN)*rat1;            
            IIM(i,j)=0;
         else
            IIM(i,j)=(h_yP-h_yOfxP)*rat2+(h_yN-h_yOfxN)*rat1;
            %IIM(i,j)=((h_y-h_yOfxN)+(h_y-h_yOfxP))/2;
         end
     end
 end
 IIM
