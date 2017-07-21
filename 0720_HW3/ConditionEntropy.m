function [h_y,h_yOfX] = ConditionEntropy(data,f1,f2,NorP)
    %ConditionEntropy: H(f1->f2)
    %NorP:1 is Positive,2 is Negative
    
    %y(x+)
    if NorP==1
         c=0;
         %找出x大於等於0是在第幾個
         for i=1:size(data,1)
             if data(i,f1)>=0
                 c=c+1;
                 xP(c,1)=data(i,f1);
                 xP_yIndex(c)=i;
             end
         end
         %找出x是大於等於0時的y值
         for i=1:c
             yOfxP(i,1)=data(xP_yIndex(i),f2);
         end
         
         [delta_r,y_pdf,range]=getPdf(data(:,f2));
         [delta_ry,yOfxP_pdf,range]=getPdf(yOfxP);
         [delta_rx,xP_pdf,range]=getPdf(xP);
         phi=max(max(y_pdf,yOfxP_pdf)+1e-10,1);
         %H(Y|X)
         h_yOfX=sum(xP_pdf.*sum(yOfxP_pdf.*log((phi)./yOfxP_pdf))).*delta_ry.*delta_rx;
         %H(Y)
         h_y=sum(y_pdf.*log((phi)./y_pdf).*delta_r);
    end
    %y(x-)
    
    if NorP==2
         c=0;
         %找出x小於0是在第幾個
         for i=1:size(data,1)
             if data(i,f1)<0
                 c=c+1;
                 xN(c,1)=data(i,f1);
                 xN_yIndex(c)=i;     
             end
         end
         %找出x是小於0時的y值
         for ii=1:c
             yOfxN(ii,1)=data(xN_yIndex(ii),f2);
         end
         
         [delta_r ,y_pdf,range]=getPdf(data(:,f2));
         [delta_ry,yOfxN_pdf,range]=getPdf(yOfxN);
         [delta_rx, xN_pdf,range]=getPdf(xN);
         phi=max(max(y_pdf,yOfxN_pdf)+1e-10,1);
         %H(Y|X)
         h_yOfX=sum(xN_pdf.*sum(yOfxN_pdf.*log((phi)./yOfxN_pdf))).*delta_ry.*delta_rx;
         %H(Y)
         h_y=sum(y_pdf.*log((phi)./y_pdf).*delta_r);
    end
end

