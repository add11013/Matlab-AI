function [r,output,range] = getPdf(x)
%GETPD Summary of this function goes here
%   Detailed explanation goes here
    
    range=linspace(mean(x)-5*std(x),mean(x)+5*std(x),500);
    pd=fitdist(x,'kernel');
    r=range(2)-range(1);
    output=pdf(pd,range);
end
% 
%          c=0;
%          for i=1:size(TrainData(1).value,1)
%              if TrainData(1).value(i,31)>=0
%                  c=c+1;
%                  xP(c,1)=TrainData(1).value(i,31);
%                  xP_yIndex(c)=i;
%              end
%          end
%          for i=1:c
%              yOfxP(i,1)=TrainData(1).value(xP_yIndex(i),30);
%          end