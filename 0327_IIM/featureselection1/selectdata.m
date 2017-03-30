function [ sample11,sample22,sample33 ] = selectdata( data,locx,locy,cas)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
a=locx;
b=locy;
sample11=[];sample22=[];sample33=[];
if(cas==1)
    for i=1:length(data)
        if(data(i,a)>=0)
            sample11=[sample11;(data(i,a))];
            sample22=[sample22;(data(i,b))];
            if(data(i,b)>=0)
                sample33=[sample33;(data(i,b))];
            end
        end
    end
    if isempty(sample33)
        sample33=sample22;
    end
end
if(cas==2)
    for i=1:length(data)
        if(data(i,a)>=0)
            sample11=[sample11;(data(i,a))];
            sample22=[sample22;(data(i,b))];
            if(data(i,b)<0)
                sample33=[sample33;(data(i,b))];
            end
        end
    end
    if isempty(sample33)
        sample33=sample22;
    end
end

if(cas==3)
    for i=1:length(data)
        if(data(i,a)<0)
            sample11=[sample11;(data(i,a))];
            sample22=[sample22;(data(i,b))];
            if(data(i,b)<0)
                sample33=[sample33;(data(i,b))];
            end
        end
    end
    if isempty(sample33)
        sample33=sample22;
    end
end

if(cas==4)
    for i=1:length(data)
        if(data(i,a)<0)
            sample11=[sample11;(data(i,a))];
            sample22=[sample22;(data(i,b))];
            if(data(i,b)>=0)
                sample33=[sample33;(data(i,b))];
            end
        end
    end
    if isempty(sample33)
        sample33=sample22;
    end
end

end

