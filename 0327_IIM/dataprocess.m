temp=xlsread('Data_set.csv');
tsmc=temp(:,2);

NumberOfData=length(tsmc);
for j=1:7
    k=j;
    for i=1:NumberOfData-7
        TMP(i,j)=tsmc(k+1)-tsmc(k);
        k=k+1;
    end
end
data=TMP;