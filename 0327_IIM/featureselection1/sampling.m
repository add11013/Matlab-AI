function [ y,xx] = sampling( sample )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
pd=fitdist(sample,'kernel');
%pd=fitdist(sample,'normal');
temp=500;
ssam2=linspace(pd.mean-pd.std*5,pd.mean+pd.std*5,temp);
y=pdf(pd,ssam2);
xx=ssam2(2)-ssam2(1);

end

