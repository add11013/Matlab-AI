function [r,output,range] = getPdf(x)
%GETPD Summary of this function goes here
%   Detailed explanation goes here
    
    pd=fitdist(x,'kernel');
    range=linspace(pd.mean-5*pd.std,pd.mean+5*pd.std,500);
    r=range(2)-range(1);
    output=pdf(pd,range);
end