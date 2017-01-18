clear
clc
close all;

target1;

%% PSO initialization
swarm_size = 64;                       % number of the swarm particles
maxIter = 300;                         % maximum number of iterations
inertia = 0.8;                        % W
correction_factor = 2.0;               % c1,c2
velocity(1:swarm_size,1:20) = 0;       % set initial velocity for particles
pbest(1:swarm_size) = 1000000;         % initial pbest distance
gbest=1;                               % the best swarm
gbestDistance=1000;                    % the error of best swarm

for i=1:swarm_size
   %Premise parameters
       for j=1:8
           swarm(i,j)=rand(1)*10;                
       end
   %Consequence parameter(T-S)
       for j=9:20
            swarm(i,j)=rand(1);             
       end
end
    PlotFuzzyset;

%% PSO main loop
for ite=1:maxIter
    for i=1:swarm_size       
       %model
        for j=1:98
          %IFpart(Rule)
           beta(1,j)=gaussmf(y(j),swarm(i,1:2))*gaussmf(y(j+1),swarm(i,5:6));
           beta(2,j)=gaussmf(y(j),swarm(i,1:2))*gaussmf(y(j+1),swarm(i,7:8));
           beta(3,j)=gaussmf(y(j),swarm(i,3:4))*gaussmf(y(j+1),swarm(i,5:6));
           beta(4,j)=gaussmf(y(j),swarm(i,3:4))*gaussmf(y(j+1),swarm(i,7:8));
          %THENpart(T-s)
           y1(1,j)=swarm(i,9)+swarm(i,10)*y(j)+swarm(i,11)*y(j+1);
           y1(2,j)=swarm(i,12)+swarm(i,13)*y(j)+swarm(i,14)*y(j+1);
           y1(3,j)=swarm(i,15)+swarm(i,16)*y(j)+swarm(i,17)*y(j+1);
           y1(4,j)=swarm(i,18)+swarm(i,19)*y(j)+swarm(i,20)*y(j+1);
           
          %yHead(output)
           for rule=1:4
              g(rule)=sum(beta(rule,:))/sum(beta(:));
              yyHead(rule,j)=y1(rule,j)*g(rule);
           end
            yHead(j)=sum(yyHead(:,j));
          %caculate error
           e(j)=(y(j+2)-yHead(j))^2; % target-yHead
        end
        
        
       %mse index
        rmse(i)=sqrt(sum(e)/98);
       %pbest
        if rmse(i)<pbest(i)
            swarmPbest(i,:)=swarm(i,:); %update pbest position
            pbest(i)=rmse(i);               %update pbest pbest mse index
        end
       %gbest
        if pbest(i)<gbestDistance
            gbest=i;                    %update which one is gbest
            gbestDistance=pbest(i);          %update distance of gbest
        end
        
       %update velocity
        A=inertia*velocity(i,:);%w
        B=correction_factor*rand(1)*(swarmPbest(i,:)-swarm(i,:));%pbest
        C=correction_factor*rand(1)*(swarm(gbest,:) - swarm(i,:));%gbest
        velocity(i,:)=A+B+C;
       %move
        swarm(i,:)=velocity(i,:)+swarm(i,:);
    end
    
    plotMSE(ite) = gbestDistance;
end


%% result
% OUTPUT and Target
    figure(1);
    x=linspace(x(3),x(100),98);
       for j=1:98
          %IFpart(Rule)
           beta(1,j)=gaussmf(y(j),swarm(gbest,1:2))*gaussmf(y(j+1),swarm(gbest,5:6));
           beta(2,j)=gaussmf(y(j),swarm(gbest,1:2))*gaussmf(y(j+1),swarm(gbest,7:8));
           beta(3,j)=gaussmf(y(j),swarm(gbest,3:4))*gaussmf(y(j+1),swarm(gbest,5:6));
           beta(4,j)=gaussmf(y(j),swarm(gbest,3:4))*gaussmf(y(j+1),swarm(gbest,7:8));
          %THENpart(T-s)
           y1(1,j)=swarm(gbest,9)+swarm(gbest,10)*y(j)+swarm(gbest,11)*y(j+1);
           y1(2,j)=swarm(gbest,12)+swarm(gbest,13)*y(j)+swarm(gbest,14)*y(j+1);
           y1(3,j)=swarm(gbest,15)+swarm(gbest,16)*y(j)+swarm(gbest,17)*y(j+1);
           y1(4,j)=swarm(gbest,18)+swarm(gbest,19)*y(j)+swarm(gbest,20)*y(j+1);
          %yHead(output)
           for rule=1:4
              g(rule)=sum(beta(rule,:))/sum(beta(:));
              yyHead(rule,j)=y1(rule,j)*g(rule);
           end
              yHead(j)=sum(yyHead(:,j));
       end
       
       % Learning Curve log
        figure(2)
        semilogy(plotMSE)
        legend('Learning Curve');
        xlabel('iterations');
        ylabel('semilogy(mse)');
        
       % Learning Curve  
        figure(5)
        plot(1:maxIter,plotMSE,'x')
        legend('Learning Curve');
        xlabel('iterations');
        ylabel('mse');
        
        figure(1)
        plot(x,yHead,'--');
        xlabel('X');
        ylabel('Y');
        legend('target','model output');


    afterPlot;

