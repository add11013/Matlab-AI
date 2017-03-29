function output = Entro2(data,f1,f2)
%ENTRO2 Summary of this function goes here
%   Detailed explanation goes here


%y(x+)?y(x-)
c=1;
    for i=1:length(data)
        if data(i,f1)>0
            xP(c,1)=data(i,f1);
            xP_yIndex(c)=i;
            c=c+1;
        end
    end
    for i=1:c-1
        yOfxP(i)=data(xP_yIndex(i),f2);
    end
    
    pd=fitdist(xP,'kernel');
    range=linspace(mean(xP)-5*std(xP),mean(xP)+5*std(xP),300);
    y=pdf(pd,range);
    for i=1:length(xP)
        p(i)=-y(i)*log2(y(i));
    end
    output=sum(p);
end

