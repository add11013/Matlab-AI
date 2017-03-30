function [ zz ] = hxy2( yy1,xx1,yy3,xx3,maxdelta)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


y=yy1'*yy3;
lambda=2;deltaIc=1/(maxdelta*lambda+1e-300);
for i = 1:300
    xxx(:,i)=y(:,i)./yy1';
end
yy=y.*log(xxx*deltaIc);
zz=sum(sum(yy))*(-1)*xx1*xx3;

end
