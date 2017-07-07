temp=xlsread('Data_set.csv');
%% TSMC
tsmc=temp(:,2);
Updown=7;
NumberOfData=length(tsmc);
for j=1:Updown
    k=j;
    for i=1:NumberOfData-Updown
        TMP(i,j)=tsmc(k+1)-tsmc(k);
        k=k+1;
    end
end
data(1).value=TMP;

%% IBM
tsmc=temp(:,1);
NumberOfData=length(tsmc);
for j=1:Updown
    k=j;
    for i=1:NumberOfData-Updown
        TMP(i,j)=tsmc(k+1)-tsmc(k);
        k=k+1;
    end
end
data(2).value=TMP;