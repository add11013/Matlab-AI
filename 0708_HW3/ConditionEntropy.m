function [h_y,h_yOfX] = ConditionEntropy(data,f1,f2,NorP)
    %ConditionEntropy: H(f1->f2)
    %NorP:1 is Positive,2 is Negative
    
    %y(x+)
    if NorP==1
         c=0;
         for i=1:size(data,1)
             if data(i,f1)>=0
                 c=c+1;
                 xP(c,1)=data(i,f1);
                 xP_yIndex(c)=i;
             end
         end
         for i=1:c
             yOfxP(i,1)=data(xP_yIndex(i),f2);
         end
         [r,y_pdf]=getPdf(data(:,f2));
         [ry,yOfxP_pdf]=getPdf(yOfxP);
         [rx,xP_pdf]=getPdf(xP);
         %phi=max(max(xP_pdf,yOfxP_pdf)+1e-300,1);
         a=[y_pdf,yOfxP_pdf];
         phi=max(max(a),1)+1e-300;
         h_yOfX=sum(xP_pdf.*sum(yOfxP_pdf.*log((phi)./yOfxP_pdf))).*ry.*rx;
         %output=sum((xP_pdf.*ry.*sum(yOfxP_pdf.*log(phi./yOfxP_pdf)))).*rx;
         h_y=sum(y_pdf.*log((phi)./y_pdf).*r);
    end
    %y(x-)
    
    if NorP==2
         c=0;
         for i=1:size(data,1)
             if data(i,f1)<0
                 c=c+1;
                 xN(c,1)=data(i,f1);
                 xN_yIndex(c)=i;     
             end
         end
         for ii=1:c
             yOfxN(ii,1)=data(xN_yIndex(ii),f2);
         end
             [r ,y_pdf]=getPdf(data(:,f2));
             [ry,yOfxN_pdf]=getPdf(yOfxN);
             [rx, xN_pdf]=getPdf(xN);
             a=[y_pdf,yOfxN_pdf];
             phi=max(max(a),1)+1e-300;
             h_yOfX=sum(xN_pdf.*sum(yOfxN_pdf.*log((phi)./yOfxN_pdf))).*ry.*rx;
             h_y=sum(y_pdf.*log((phi)./y_pdf).*r);
    end
save result
end

