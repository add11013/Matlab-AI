function output = gaussmf(x,ca,choice)
%GAUSS Summary of this function goes here
%   Detailed explanation goes here
c=ca(1);
a=ca(2);
switch choice
    case 1 %normal
        output=exp(-0.5.*((x-c)./a).^2);
    case 2 %1st-x
        output=exp(-0.5.*((x-c)./a).^2).*-1.*(x-c)./a.^2;
    case 3 %2st-x
        output=exp(-0.5.*((x-c)./a).^2).*(-1.*(x-c)./a.^2).^2+(-1)./a.^2.*exp(-0.5.*((x-c)./a).^2);
    case 4 %3st-x
        output=exp(-0.5.*((x-c)./a).^2).*((2.*(x-c)./(a.^4))+-1.*(x-c).^3./a.^6);
    case 5 %1st-c
        output=exp(-0.5.*((x-c)./a).^2).*(x-c)./a.^2;
    case 6 %2st-c
        output=exp(-0.5.*((x-c)./a).^2).*(-1.*(x-c)./a.^2).^2+(-1)./a.^2.*exp(-0.5.*((x-c)./a).^2);
    case 7 %3st-c
        output=exp(-0.5.*((x-c)./a).^2).*((-3.*(x-c).*a^2+(x-c).^3)/a.^6);
    case 8 %1st-a
        output=exp(-0.5.*((x-c)./a).^2).*((x-c).^2./a.^3);
    case 9 %2st-a
        output=exp(-0.5.*((x-c)./a).^2).*((x-c).^4./a.^6+(-3.*(x-c).^2)./a.^4);
    case 10 %3st-a
        output=exp(-0.5.*((x-c)./a).^2).*((-9.*a.^2.*(x-c).^4)+((x-c).^6)+(12.*a.^4.*(x-c).^2))./a.^9;
end

end

