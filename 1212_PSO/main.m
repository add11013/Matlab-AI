clear
clc
close all;

x=linspace(-2,2);
for i=1:100
    y(i)=x(i)^2+10;
end
plot(x,y);

c11=4;a11=10;c21=10;a21=10;c12=4;a12=10;c22=10;a22=10;
for i=2:100
    x1=y(i);
    x2=y(i-1);
    
end



%% initialization
swarm_size = 64;                       % number of the swarm particles
maxIter = 500;                         % maximum number of iterations
inertia = 1;                           % W
correction_factor = 2.0;               % c1,c2
for i=1:swarm_size
    velocity(i,1:14) = 0;              % set initial velocity for particles
    swarm(i,1)=c11;                      %c11
    swarm(i,2)=a11;                     %a11
    swarm(i,3)=c21;                     %c21
    swarm(i,4)=a21;                     %a21
    swarm(i,5:7)=0;                    %A01?A11?A21
    swarm(i,8)=c12;                      %c12
    swarm(i,9)=a12;                     %a12
    swarm(i,10)=c22;                    %c22
    swarm(i,11)=a22;                    %a22
    swarm(i,12:14)=0;                  %A02?A12?A22
end
pbest(1:swarm_size) = 1000;            % pbest
gbest=1;

    

%% main loop
% for i=1:maxIter
% 
%     
%     %move
%     swarm(:,:) = swarm(:,:) + velocity(:,:);
%     
%     
%     
%     %change velocity
%     for i=1:swarm_size
%         A=inertia*velocity(i,:);%??
%         B=correction_factor*rand(1)*0.1*(pbestPos(i,:)-swarm(i,:));%pbest
%         C=correction_factor*rand(1)*0.1*(pbestPos(gbest,:) - swarm(i,:));%gbest
%         velocity(i,:)=A+B+C;
%     end
% end

%% result



