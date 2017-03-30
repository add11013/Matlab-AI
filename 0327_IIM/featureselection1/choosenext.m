function [ cost,ind,rri ] = choosenext( allii,targ,box,rri )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

for i=1:targ
    if(allii(i,targ)>0)
        
        ii=allii(i,targ);
        ri=0;
        for k=1:length(box(:,1))
            ri=ri+allii(i,box(k,1))+allii(box(k,1),i);
            
        end
        %rrri(i)=ri+rri;
        ri=(ri)/(length(box(:,1))*2);
        costt(i)=(ii-ri);  
        cori(i)=ri;
    else
        costt(i)=-100000;
    end
end
[cost,ind]=max(costt);
%rri=rrri(ind);
end

