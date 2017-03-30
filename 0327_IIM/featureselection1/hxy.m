function [ abc ] = hxy(yy1,xx1,yy3,xx3,maxdelta)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


sum3=0;lambda=maxdelta;fi=lambda+1;
for i=1:500
        sum3=sum3+yy3(i)*log(fi/yy3(i));
end
abc=sum3*xx3;

end

