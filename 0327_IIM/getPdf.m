function output = getPdf(x)
%GETPD Summary of this function goes here
%   Detailed explanation goes here
    pd=fitdist(x,'kernel');
    range=linspace(mean(x)-5*std(x),mean(x)+5*std(x),300);
    output=pdf(pd,range);
end

