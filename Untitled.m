clear
clc
tic
k=0;
PI=0;
e=0.0001;
while e<abs(3.141592653589793-PI)
    s=0;
    for n=0:k
        tmp=(-1)^n/(2*n+1);
        s=s+tmp;
    end
    PI=4*s;
    k=k+1;
end
k
toc