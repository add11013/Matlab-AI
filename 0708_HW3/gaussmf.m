function output = gaussmf(x,ca,choice)
%GAUSS Summary of this function goes here
%   Detailed explanation goes here
c=ca(1);
a=ca(2);

    switch choice
        %% Theata1
        case 1 %normal
            output=exp(-0.5.*((x-c)./a).*conj((x-c)./a));
        case 2 %dy/dx
            output=exp(-0.5.*((x-c)./a).*conj((x-c)./a)).*-1.*(x-c)./a.*conj(a);
        case 3 %dy/dc
            output=exp(-0.5.*((x-c)./a).*conj((x-c)./a)).*(x-c)./a.*conj(a);
        case 4 %dy/da
            output=exp(-0.5.*((x-c)./a).*conj((x-c)./a)).*((x-c).*conj(x-c)./a.^3);
        
        %% Theata2
        case 5 %d2y/dx2
            output=exp(-0.5.*((x-c)./a).^2).*(-1.*(x-c)./a.^2).^2+(-1)./a.^2.*exp(-0.5.*((x-c)./a).^2);
        case 6 %d2y/dxdc
            output=exp(-0.5.*((x-c)./a).^2).*(1./a.^2+(-(x-c).^2./a.^4));
        case 7 %d2y/dxda
            output=exp(-0.5.*((x-c)./a).^2).*(2.*(x-c)./a.^3+-(x-c).^3./a.^5);
            
        case 8 %d2y/dcdx
            output=exp(-0.5.*((x-c)./a).^2).*(1./a.^2+(-(x-c).^2./a.^4));
        case 9 %d2y/dc2
            output=exp(-0.5.*((x-c)./a).^2).*(-1.*(x-c)./a.^2).^2+(-1)./a.^2.*exp(-0.5.*((x-c)./a).^2);
        case 10 %d2y/dcda
            output=exp(-0.5.*((x-c)./a).^2).*(-2.*(x-c)./a.^3+((x-c).^3./a.^5));
            
        case 11 %d2y/dadx
            output=exp(-0.5.*((x-c)./a).^2).*((2.*(x-c)./a.^3)+(-(x-c).^3/a.^5));
        case 12 %d2y/dadc
            output=exp(-0.5.*((x-c)./a).^2).*((-2.*(x-c)./a.^3)+(x-c).^3/a.^5);
        case 13 %d2y/da2
            output=exp(-0.5.*((x-c)./a).^2).*((x-c).^4./a.^6+(-3.*(x-c).^2)./a.^4);
    end

end

