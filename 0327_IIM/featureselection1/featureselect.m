function [ box ] = featureselect( alli )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

box=[];allii=alli;
targ=length(alli);
[ii,x]=choosemax(alli,targ);
box=[box;[x,ii]];
allii(x,targ)=0;
rri=0;
for i=1:targ-2
    [cost,x,rri]=choosenext(allii,targ,box,rri);
    box=[box;[x,cost]];
    allii(x,targ)=0;
end

end

