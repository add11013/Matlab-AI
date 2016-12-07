function output = gaussmf(x,c,a)
%GAUSS Summary of this function goes here
%   Detailed explanation goes here
output=exp(-0.5.*((x-c)./a).^2);

end

