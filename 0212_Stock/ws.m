function u= ws(x,ca,l)
%WS Summary of this function goes here
%   Detailed explanation goes here
        r=gaussmf(x,ca);
        w=-((x-ca(1))/(ca(2)^2)).*r.*l;
        u1=r.*cos(w)+j*r.*sin(w);
        u=imag(u1)+real(u1);
end

