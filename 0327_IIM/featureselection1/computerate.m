function [ rat1,rat2 ] = computerate( sample )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
rat1=0;rat2=0;
pd=fitdist(sample,'kernel');
%pd=fitdist(sample,'normal');

temp=300;
ssam2=linspace(pd.mean-pd.std*5,pd.mean+pd.std*5,temp);
y=pdf(pd,ssam2);
xx=ssam2(2)-ssam2(1);
min=1e3000;ii=0;
for i=1:temp
    if(min>ssam2(i)^2)
        min=ssam2(i)^2;
        ii=i;
    end
end
for i=1:ii
    rat1=rat1+y(i)*xx;
end

for i=ii+1:temp
    rat2=rat2+y(i)*xx;
end
a=1;

end

