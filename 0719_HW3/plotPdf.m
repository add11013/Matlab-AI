clear
clc
close all
load('TrainData');
figure(1)
hold on
%% get Pdf of X
[r x_pdf range]=getPdf(TrainData(1).value(:,1));
plot(range,x_pdf);
%% get Pdf of Y
[r output range]=getPdf(TrainData(1).value(:,61));
plot(range,output);


         c=0;
         for i=1:size(TrainData(1).value,1)
             if TrainData(1).value(i,1)>=0
                 c=c+1;
                 xP(c,1)=TrainData(1).value(i,1);
                 xP_yIndex(c)=i;
             end
         end
         for i=1:c
             yOfxP(i,1)=TrainData(1).value(xP_yIndex(i),2);
         end
%% get Pdf of Y|X
[r output range]=getPdf(yOfxP);
plot(range,output);


[r,y_pdf,range]=getPdf(TrainData(1).value(:,61));
[ry,yOfxP_pdf,range]=getPdf(yOfxP);
[rx,xP_pdf,range]=getPdf(xP);
a=[y_pdf,yOfxP_pdf];
phi=max(max(a)+1e-10,1);

%% H(X|Y)
h_yOfX=sum(xP_pdf.*sum(yOfxP_pdf.*log((phi)./yOfxP_pdf))).*ry.*rx;

%% H(Y)
h_y=sum(y_pdf.*log((phi)./y_pdf).*r);

%% H(X)
h_x=sum(x_pdf.*log((phi)./x_pdf).*r);
%% I(X+,Y)=H(Y)-H(Y|X)
I=h_y-h_yOfX;

legend('X','Y','Y|X')