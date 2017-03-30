function [ sum ] = hxy3( yy1,xx1,yy3,xx3,maxdelta)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

lambda=maxdelta;fi=lambda+1;
sum=0;
for i=1:length(yy1)
   for j=1:length(yy3)
      sum=sum+yy3(j)*yy1(i)*log(fi/yy3(j))*xx1*xx3; 
   end
end

end

