function [ alli,eachgain] = featureselection( trr1 )%INPUT是輸入的資料集
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

alli=computeall(trr1)
eachgain=featureselect(alli)
%pic(alli);

%hxy(yy3,xx3,maxdelta);
%hxy3(yy1,xx1,yy3,xx3,maxdelta);

end

