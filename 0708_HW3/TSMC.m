figure(1);
hold on
temp=xlsread('Data_set.csv');
DataOfTest=temp(0.7*length(temp):length(temp),1);
DataOfTrain=temp(1:0.7*length(temp),1);

NumberOfTestPoint=length(DataOfTest);
NumberOfTrainPoint=length(DataOfTrain);
NumberOfAllPoint=NumberOfTrainPoint+NumberOfTestPoint;
x=linspace(1,NumberOfAllPoint,NumberOfAllPoint);
y=[(DataOfTrain(:,1));(DataOfTest(:,1))];
yMean=mean(y);
yStd=std(y);
plot(x,y);

