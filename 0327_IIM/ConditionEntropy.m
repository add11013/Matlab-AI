function output = ConditionEntropy(data,f1,f2,NorP)
    %ConditionEntropy: H(f1->f2)
    %NorP:1 is Positive,2 is Negative
    
    %y(x+)
    if NorP==1
         c=0;
         for i=1:size(data,1)
             if data(i,f1)>0
                 c=c+1;
                 xP(c,1)=data(i,f1);
                 xP_yIndex(c)=i;
             end
         end
         for i=1:c
             yOfxP(i,1)=data(xP_yIndex(i),f2);
         end
         [r y_pdf]=getPdf(data(:,f2));
         [ry yOfxP_pdf]=getPdf(yOfxP);
         [rx xP_pdf]=getPdf(xP);
         phi=max(max(xP_pdf,yOfxP_pdf)+10e-10,1);
         output=sum((xP_pdf.*ry.*sum(yOfxP_pdf.*log(phi./yOfxP_pdf)))).*rx;
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
         if exist('yOfxN','var')
             [r y_pdf]=getPdf(data(:,f2));
             [ry yOfxN_pdf]=getPdf(yOfxN);
             [rx xN_pdf]=getPdf(xN);
             phi=max(max(xN_pdf,yOfxN_pdf)+10e-10,1);
             output=sum(xN_pdf.*ry.*sum(yOfxN_pdf.*log(phi./yOfxN_pdf))).*rx;
         else
             output=0;
         end
    
    end
end

