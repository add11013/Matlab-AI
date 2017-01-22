clear;
close all;
clc;
tic
target;
%% substractive clustering
h1=y(1:point-2);
h2=y(1:point-1);
h1std=std(h1);
h2std=std(h2);
h1Center=subclust(h1,0.3);
h2Center=subclust(h2,0.3);

%% formation matrix
k=1;
for i=1:length(h1Center)
    for j=1:length(h2Center)
        formationMatrix(k,1)=i;
        formationMatrix(k,2)=j;
        k=k+1;
    end
end

%% 




toc


