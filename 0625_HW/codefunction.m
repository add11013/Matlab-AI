function output=codefunction(r,x,ca,g1,g2,dimension)    
    %dy/dc
    theata=gaussmf(x,ca,g1);
    result(dimension)=0;
    U(4).value=r.*exp(j.*(gaussmf(x,ca,g1)+gaussmf(x,ca,g2)));
    %% codefunction
    while (dimension~=2)
        u(dimension).value=r.*sin(theata);
        r=r.*cos(theata);
        if dimension==1
            theata=gaussmf(x,ca,g1);
        else
            theata=gaussmf(x,ca,g2);
        end
        dimension=dimension-1;
    end
    u(2).value=r.*sin(theata);
    u(1).value=r.*cos(theata);

    %% membership value

    U(1).value=u(1).value+j.*u(2).value;
    U(2).value=u(2).value+j.*u(3).value;
    U(3).value=u(3).value+j.*u(1).value;


    for i=1:4
        subplot(2,2,i)
        A=imag(U(i).value);
        B=real(U(i).value);
        plot3(x,A,B);
    end