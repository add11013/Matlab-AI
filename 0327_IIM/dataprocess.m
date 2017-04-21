

tsmc=xlsread('tsmc.csv');
NumberOfData=length(tsmc);
for i=1:NumberOfData-30
    for j=1:30
        TMP(i,j)=tsmc(i+j)-tsmc(j);
    end
    TMP(i,31)=tsmc(i+j);
end
data=TMP;