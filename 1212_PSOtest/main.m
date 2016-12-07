clear
clc
close all;
x1=linspace(-1,1,50);
x2=linspace(-1,1,50);
[xx1,xx2]=meshgrid(x1,x2);
y=xx1.^2+xx2.^2+10;
mesh(x1,x2,y)
Input(:,:)=[x1,x2];
%% PSO
