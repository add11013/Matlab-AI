function output = fcost(X,Xopt)
%FCOST Summary of this function goes here
%   Detailed explanation goes here
        Xtmp=X-Xopt;
        output=Xtmp*transpose(Xtmp)+5;

end

