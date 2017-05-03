

tsmc=xlsread('tsmc.csv');
NumberOfData=length(tsmc);
for j=1:31
    k=j;
    for i=1:NumberOfData-31
        TMP(i,j)=tsmc(k+1)-tsmc(k);
        k=k+1;
    end
end
data=TMP;