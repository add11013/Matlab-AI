% set the position of the initial swarm
%swarm(:,1,:) position ;swarm(:,2,:) velocity;swarm(:,3,:) best position;swarm(:,4,:) best error value 
%initial position
for i=1:swarm_size
    for j=1:8
        swarm(i,1,j)=randi(100);
    end
    for j=9:16
        swarm(i,1,j)=randi(800);
    end
    swarm(i,2,:) = 0;                      % set initial velocity for particles
    swarm(i,4,1) = 100000;                   % pbest
    swarm(i,5,:)=swarm(i,1,:);
    %temperature(-20~20)
%     for j=1:4
%         swarm(i,1,j)=-20+40*rand(1);
%     end    
%     %quantity(1~100)
%     for j=5:8
%         swarm(i,1,j)=randi(100);
%     end
%     %power(300~1000)
%     for j=9:16
%         swarm(i,1,j)=rand(1)*700+300;
%     end
end