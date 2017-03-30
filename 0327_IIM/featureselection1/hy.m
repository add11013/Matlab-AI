function [ tp ] = hy(yy2,xx2,maxdelta )

sum=0;lambda=maxdelta;fi=lambda+1;
for i =1:500
    aaaa(i)=yy2(i)*log(fi/yy2(i));
    sum=sum+aaaa(i);
end
tp=sum*xx2;

end

