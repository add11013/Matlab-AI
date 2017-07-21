%caculate Number Of Target
NumberOfTarget=size(OriginalData,2);
%Cacurate diff. of all Feature and save as data(t).value
for t=1:NumberOfTarget
    tsmc=OriginalData(:,t);
    ColOfTarget=31;%(º¦¶^)+1
    LengthOfData=length(tsmc);
    for jj=1:ColOfTarget
        k=jj;
        for i=1:LengthOfData-ColOfTarget
            TMP(i,jj)=tsmc(k+1)-tsmc(k);
            k=k+1;
        end
    end
    data(t).value=TMP;
end