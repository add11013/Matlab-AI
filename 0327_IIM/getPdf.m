function [r output] = getPdf(x)
%GETPD Summary of this function goes here
%   Detailed explanation goes here
    
    range=linspace(mean(x)-5*std(x),mean(x)+5*std(x),200);
    pd=fitdist(x,'kernel');
    r=range(2)-range(1);
    output=pdf(pd,range);
end

