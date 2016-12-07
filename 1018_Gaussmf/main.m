for i=1:100
    x(i)=i;
    y(i)=gaussmf(x(i),50,10); %GaussMF(x,c,a)
end
plot(x,y);