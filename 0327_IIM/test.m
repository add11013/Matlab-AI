clear
clc
load data.csv

 for i=1:size(data,2)
     for j=1:size(data,2)
         %H(Y)
         h_y=getEntropy(data(:,j));
         %H(Y(X+))
         h_yOfxP=Entro2(data,i,j);
         %H(Y(X-))
         h_yOfxN=Entro(data,i,j);
         
         
         IIM(i,j)=((h_y-h_yOfxN)+(h_y-h_yOfxP))/2;
     end
 end
