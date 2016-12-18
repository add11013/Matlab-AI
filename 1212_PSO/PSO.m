clear
clc
close all;
%% target
x=linspace(-2,2);
for i=1:100
    y(i)=x(i).^2+10;
end
plot(x,y);
ca={[5,10] [10,10] [-1,10] [1,10]};
for i=1:4
    a0(i)=0;
    a1(i)=0;
    a2(i)=0;
end



%% initialization
swarm_size = 64;                       % number of the swarm particles
maxIter = 100;                         % maximum number of iterations
inertia = 1;                           % W
correction_factor = 2.0;               % c1,c2
velocity(1:swarm_size,1:20) = 0;       % set initial velocity for particles
pbest(1:swarm_size) = 1000;            % pbest distance
gbest=1;
gbestDistance=1000;
s=0;
for i=1:swarm_size
    swarm(i,1)=ca{1}(1);
    swarm(i,2)=ca{1}(2);
    swarm(i,3)=a0(1);
    swarm(i,4)=a1(1);
    swarm(i,5)=a2(1);
    swarm(i,6)=ca{1}(1);
    swarm(i,7)=ca{1}(1);
    swarm(i,8)=a0(2);
    swarm(i,9)=a1(2);
    swarm(i,10)=a2(2);
    swarm(i,11)=ca{1}(1);
    swarm(i,12)=ca{1}(1);
    swarm(i,13)=a0(3);
    swarm(i,14)=a1(3);
    swarm(i,15)=a2(3);
    swarm(i,16)=ca{1}(1);
    swarm(i,17)=ca{1}(1);
    swarm(i,18)=a0(4);
    swarm(i,19)=a1(4);
    swarm(i,20)=a2(4);
end
    

%% main loop
for ite=1:maxIter
    for k=1:swarm_size
        %move
        swarm(k,:)=velocity(k,:)+swarm(k,:);
        yHead=0;
        for i=1:98
            for j=1:4
                B(j)=gaussmf(y(i),ca{j})*gaussmf(y(i+1),ca{j});
                R(j)=B(j)*a0(j)+a1(j)*y(i)+a2(j)*y(i+1);
            end
            for j=1:4
                yHead=B(j)*R(j)+yHead;
            end
            yHead=yHead/sum(B);
            error(i)=y(i+2)-yHead;
        end
        for i=1:98
            s=error(i)+s;
        end
            e=s/98;  
    
        if e<pbest(k)
            pbestPos(k,:)=swarm(k,:);
            pbest(k)=e;
        end
        if e<gbestDistance
            gbest=k;
        end
     end
    
    
    %change velocity
    for i=1:swarm_size
        A=inertia*velocity(i,:);%??
        B=correction_factor*rand(1)*0.1*(pbestPos(i,:)-swarm(i,:));%pbest
        C=correction_factor*rand(1)*0.1*(pbestPos(gbest,:) - swarm(i,:));%gbest
        velocity(i,:)=A+B+C;
    end
end

%% result




