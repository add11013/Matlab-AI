
%ERROR Summary of this function goes here
%   Detailed explanation goes here
z=linspace(-20,100,101);
e=zeros(1,100);
for i=1:100
    t1(i,1)=target(z(i));
    t2(i,1)=fuzzyrule(z(i),z(i+1),100);
end
e=sqrt(sum((t1-t2).^2)/100);



