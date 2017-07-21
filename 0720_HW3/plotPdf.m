clear
clc
close all
load('IIMData');
figure(1)
hold on
%% get Pdf of X
[delta_x x_pdf domain]=getPdf(IIMData(1).value(1:200,1));
plot(domain,x_pdf);
Xarea=sum(x_pdf*delta_x);
%% get Pdf of Y
[delta_y y_pdf domain]=getPdf(IIMData(1).value(1:200,61));
plot(domain,y_pdf);
Yarea=sum(y_pdf*delta_y);


         c=0;
         for i=1:size(IIMData(1).value(1:200,:),1)
             if IIMData(1).value(i,1)>=0
                 c=c+1;
                 xP(c,1)=IIMData(1).value(i,1);
                 xP_yIndex(c)=i;
             end
         end
         for i=1:c
             yOfxP(i,1)=IIMData(1).value(xP_yIndex(i),2);
         end
%% get Pdf of Y|X
[delta_xy xy_pdf domain]=getPdf(yOfxP);
plot(domain,xy_pdf);
XYarea=sum(xy_pdf*delta_xy);

[r,y_pdf,domain]=getPdf(IIMData(1).value(:,61));
[ry,yOfxP_pdf,domain]=getPdf(yOfxP);
[rx,xP_pdf,domain]=getPdf(xP);
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