function u= ws(x,ca,l)
%WS Summary of this function goes here
%   Detailed explanation goes here
        j=sqrt(-1);
        r=cgsmf(x,ca);
        w=-((x-ca(1))/(ca(2)^2)).*r.*l;
        u1=r.*(cos(w)+j.*sin(w));
        u=imag(u1)+real(u1);
end

