%ERROR Summary of this function goes here
%   Detailed explanation goes here
z=linspace(-20,100,101);
e=zeros(1,100);
for ii=1:100
    t1(ii,1)=target(z(ii));
    t2(ii,1)=fuzzyrule(z(ii),z(ii+1),100);
    e(1,ii)=sqrt(sum((t1(ii,1)-t2(ii,1)).^2/100));
end
%e=sqrt(sum((t1-t2).^2)/100);




