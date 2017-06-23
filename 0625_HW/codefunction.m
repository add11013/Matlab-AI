while (dimension~=2)
    u(dimension).value=r.*sin(theata);
    r=r.*cos(theata);
    if dimension==1
        theata=gaussmf(x,ca,5);
    else
        theata=gaussmf(x,ca,6);
    end
    dimension=dimension-1;
end
u(2).value=r.*sin(theata);
u(1).value=r.*cos(theata);