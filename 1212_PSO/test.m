clear
clc
close all;

PlotTarget;

%% PSO initialization
swarm_size = 64;                       % number of the swarm particles
maxIter = 100;                         % maximum number of iterations
inertia = 0.8;                         % W
correction_factor = 2.0;               % c1,c2
velocity(1:swarm_size,1:20) = 0;       % set initial velocity for particles
pbest(1:swarm_size) = 1000;            % initial pbest distance
gbest=1;                               % the best swarm
gbestDistance=1000;                    % the error of best swarm

for i=1:swarm_size
   %Premise parameters
    swarm(i,1)=rand(1)*10;          %c1
    swarm(i,2)=rand(1)*10;          %a1
    swarm(i,3)=rand(1)*10;          %c2
    swarm(i,4)=rand(1)*10;          %a2
    swarm(i,5)=rand(1)*10;          %c3
    swarm(i,6)=rand(1)*10;          %a3
    swarm(i,7)=rand(1)*10;          %c4
    swarm(i,8)=rand(1)*10;          %a4
   %Consequence parameter(T-S)
    swarm(i,9)=rand(1);             %a10
    swarm(i,10)=rand(1);            %a11
    swarm(i,11)=rand(1);            %a12
    swarm(i,12)=rand(1);            %a20
    swarm(i,13)=rand(1);            %a21
    swarm(i,14)=rand(1);            %a22
    swarm(i,15)=rand(1);            %a30
    swarm(i,16)=rand(1);            %a31
    swarm(i,17)=rand(1);            %a32
    swarm(i,18)=rand(1);            %a40
    swarm(i,19)=rand(1);            %a41
    swarm(i,20)=rand(1);            %a42
end
    PlotFuzzyset;

%% PSO main loop
for ite=1:maxIter
    for i=1:swarm_size
        %move
        swarm(i,:)=velocity(i,:)+swarm(i,:);
        
       %model
        for j=1:98
          %IFpart(Rule)
           beta(1,j)=gaussmf(y(j),swarm(i,1:2))*gaussmf(y(j+1),swarm(i,3:4));
           beta(2,j)=gaussmf(y(j),swarm(i,3:4))*gaussmf(y(j+1),swarm(i,5:6));
           beta(3,j)=gaussmf(y(j),swarm(i,5:6))*gaussmf(y(j+1),swarm(i,7:8));
           beta(4,j)=gaussmf(y(j),swarm(i,7:8))*gaussmf(y(j+1),swarm(i,1:2));
          %THENpart(T-s)
           y1(1,j)=swarm(i,9)+swarm(i,10)*y(j)+swarm(i,11)*y(j+1);
           y1(2,j)=swarm(i,12)+swarm(i,13)*y(j)+swarm(i,14)*y(j+1);
           y1(3,j)=swarm(i,15)+swarm(i,16)*y(j)+swarm(i,17)*y(j+1);
           y1(4,j)=swarm(i,18)+swarm(i,19)*y(j)+swarm(i,20)*y(j+1);
          %yHead(output)
           for rule=1:4
              yHead(j)=y1(rule,j)*beta(rule,j)/sum(beta(:,j));
           end
          %caculate error
           e(j)=(y(j+2)-yHead(j))^2; % target-yHead
        end
        
        
       %mse index
        mse=sum(e)/98;
       %pbest
        if mse<pbest(i)
            swarmPbest(i,:)=swarm(i,:); %update pbest position
            pbest(i)=mse;               %update pbest pbest mse index
        end
       %gbest
        if mse<gbestDistance
            gbest=i;                    %update which one is gbest
            gbestDistance=mse;          %update distance of gbest
        end
        
        %update velocity
        A=inertia*velocity(i,:);%w
        B=correction_factor*rand(1)*(swarmPbest(i,:)-swarm(i,:));%pbest
        C=correction_factor*rand(1)*(swarm(gbest,:) - swarm(i,:));%gbest
        velocity(i,:)=A+B+C;
        
    end
    
    plotMSE(ite) = gbestDistance;
end


%% result
% OUTPUT and Target
    figure(1);
    x=linspace(x(3),2,98);
       for j=1:98
          %IFpart(Rule)
           beta(1,j)=gaussmf(y(j),swarm(gbest,1:2))*gaussmf(y(j+1),swarm(gbest,3:4));
           beta(2,j)=gaussmf(y(j),swarm(gbest,3:4))*gaussmf(y(j+1),swarm(gbest,5:6));
           beta(3,j)=gaussmf(y(j),swarm(gbest,5:6))*gaussmf(y(j+1),swarm(gbest,7:8));
           beta(4,j)=gaussmf(y(j),swarm(gbest,7:8))*gaussmf(y(j+1),swarm(gbest,1:2));
          %THENpart(T-s)
           y1(1,j)=swarm(gbest,9)+swarm(gbest,10)*y(j)+swarm(gbest,11)*y(j+1);
           y1(2,j)=swarm(gbest,12)+swarm(gbest,13)*y(j)+swarm(gbest,14)*y(j+1);
           y1(3,j)=swarm(gbest,15)+swarm(gbest,16)*y(j)+swarm(gbest,17)*y(j+1);
           y1(4,j)=swarm(gbest,18)+swarm(gbest,19)*y(j)+swarm(gbest,20)*y(j+1);
          %yHead(output)
           for rule=1:4
              yHead(j)=y1(rule,j)*beta(rule,j)/sum(beta(:,j));
           end
       end
       % Learning Curve
        figure,
        semilogy(plotMSE)
        legend('Learning Curve');
        figure(1)
    plot(x,yHead);
    xlabel('X');
    ylabel('Y');
    legend('target','model output');


    afterPlot;

