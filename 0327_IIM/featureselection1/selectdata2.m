function [ sample11,sample22,sample33 ] = selectdata2( data,locx,locy,cas)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
a=locx;
b=locy;
sample11=[];sample22=[];sample33=[];
if(cas==1)
    for i=1:length(data)
        sample11=[sample11;(data(i,b))];%y
        sample22=[sample22;(data(i,a))];%X
        if(data(i,a)>=0)
            sample33=[sample33;(data(i,b))];%y|x+
        end
    end

%     if isempty(sample33)
%         sample33=sample22;
%     end
end
if(cas==2)
    for i=1:length(data)
        sample11=[sample11;(data(i,b))];
        sample22=[sample22;(data(i,a))];
        if(data(i,a)<0)
            sample33=[sample33;(data(i,b))];
        end
    end

%     if isempty(sample33)
%         sample33=sample22;
%     end
end


end

