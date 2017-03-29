function output = Entro(x)
%ENTRO Summary of this function goes here
%   Detailed explanation goes here
    
    x_Mean=mean(x);
    x_std=std(x);
    pd=fitdist(x,'kernel');
    range=linspace(x_Mean-5*x_std,x_Mean+5*x_std,300);
    y=pdf(pd,range);
    plot(range,y);
    for i=1:length(x)
        p(i)=-y(i)*log2(y(i));
    end
    output=sum(p)
end

