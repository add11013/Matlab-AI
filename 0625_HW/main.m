clear
clc
c=0;
a=1;
ca=[0 1];
x=linspace(c-5*a,c+5*a,100);
dimension=3;
r=gaussmf(x,ca,1);

%dy/dc
theata=gaussmf(x,ca,3);
result(dimension)=0;

U(4).value=r.*exp(j.*(gaussmf(x,ca,3)+gaussmf(x,ca,7)));
%% codefunction
while (dimension~=2)
    u(dimension).value=r.*sin(theata);
    r=r.*cos(theata);
    if dimension==1
        theata=gaussmf(x,ca,3);
    else
        theata=gaussmf(x,ca,7);
    end
    dimension=dimension-1;
end
u(2).value=r.*sin(theata);
u(1).value=r.*cos(theata);

%% membership value

U(1).value=u(1).value+j.*u(2).value;
U(2).value=u(2).value+j.*u(3).value;
U(3).value=u(3).value+j.*u(1).value;


for i=1:3
    subplot(1,3,i)
    A=imag(U(i).value);
    B=real(U(i).value);
    plot3(x,A,B);
end