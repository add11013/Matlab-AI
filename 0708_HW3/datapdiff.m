%caculate Number Of Target
NumberOfTarget=size(OriginalData,2);
%Cacurate diff. of all Feature and save as data(t).value
for t=1:NumberOfTarget
    tsmc=OriginalData(:,t);
    Updown=31;
    LengthOfData=length(tsmc);
    for jj=1:Updown
        k=jj;
        for i=1:LengthOfData-Updown
            TMP(i,jj)=tsmc(k+1)-tsmc(k);
            k=k+1;
        end
    end
    data(t).value=TMP;
end