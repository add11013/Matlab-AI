function [ all ] = computeall( data )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
len=length(data(1,:));
for i=1:len
    for j=1:len        
            all(i,j)=computei2(data,i,j);
    end
end
end

