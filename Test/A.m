clear
close all;
clc

x=linspace(1,100);
for i=1:length(x)
    y(i)=randn;
end

hold on
plot(x,y)

y=0
x=linspace(30,50,20);
for i=1:length(x)
    y(i)=x(i)/30;
end
plot(x,y)