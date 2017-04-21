function output = gaussmf(x,ca)
%GAUSS Summary of this function goes here
%   Detailed explanation goes here
c=ca(1);
a=ca(2);
output=exp(-0.5.*((x-c)./a).^2);

end

