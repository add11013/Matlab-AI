clear
clc
for i=1:10
    for ii=1:12
        swarm(i,ii)=rand(1)
    end
end
j1=1;
for number=1:PrePara/4
    temp=[swarm(i,j1:j1+1)];
    termSet{1}(number)={temp};
    j1=j1+2;
end
for number=1:PrePara/4
    temp=[swarm(i,j1:j1+1)];
    termSet{2}(number)={temp};
    j1=j1+2;
end