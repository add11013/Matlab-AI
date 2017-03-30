function output = getPdf(x)
%GETPD Summary of this function goes here
%   Detailed explanation goes here
    
    range=linspace(mean(x)-5*std(x),mean(x)+5*std(x),300);
    pd=fitdist(x,'kernel');
    output=pdf(pd,range);
end

