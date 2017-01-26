clear
clc
close all;
tic
target1;

PrePara=12;
ConsPara=27;

%% PSO initialization
swarm_size = 64;                       % number of the swarm particles
maxIter = 30;                          % maximum number of iterations
inertia = 0.9;                         % W
correction_factor = 2.0;               % c1,c2
velocity(1:swarm_size,1:PrePara) = 0;  % set initial velocity for particles
pbest(1:swarm_size) = 1e20;            % initial pbest distance
gbest=1;                               % the best swarm
gbestDistance=1000;                    % the error of best swarm


%% parameters initial
for i=1:swarm_size
    % Premise parameters
    for j=1:PrePara
        swarm(i,j)=rand(1)*(2*yStd)+(yMean-yStd);
        %swarm(i,j)=rand(1);
    end
    count=1;

    % Consequence parameters    
    for rule=1:9
        conPara(rule,:)=[0 0 0];
       for jj=1:3
          the(count,1,i)=conPara(rule,jj);
          count=count+1;
       end
    end
    % RLSE iteration
      P(:,:,i)=10000*eye(3*9);
end

    %PlotFuzzyset;
    
%% PSO main loop
for ite=1:maxIter
    for i=1:swarm_size
       % move
        swarm(i,:)=velocity(i,:)+swarm(i,:);
        beta=[];
        %model
        for j=1:point-2
          %FireStrength
           beta(1,j)=gaussmf(y(j),swarm(i,1:2))*gaussmf(y(j+1),swarm(i,7:8));
           beta(2,j)=gaussmf(y(j),swarm(i,1:2))*gaussmf(y(j+1),swarm(i,9:10));
           beta(3,j)=gaussmf(y(j),swarm(i,1:2))*gaussmf(y(j+1),swarm(i,11:12));
           beta(4,j)=gaussmf(y(j),swarm(i,3:4))*gaussmf(y(j+1),swarm(i,7:8));
           beta(5,j)=gaussmf(y(j),swarm(i,3:4))*gaussmf(y(j+1),swarm(i,9:10));
           beta(6,j)=gaussmf(y(j),swarm(i,3:4))*gaussmf(y(j+1),swarm(i,11:12));
           beta(7,j)=gaussmf(y(j),swarm(i,5:6))*gaussmf(y(j+1),swarm(i,7:8));
           beta(8,j)=gaussmf(y(j),swarm(i,5:6))*gaussmf(y(j+1),swarm(i,9:10));
           beta(9,j)=gaussmf(y(j),swarm(i,5:6))*gaussmf(y(j+1),swarm(i,11:12));
        end
          %Normalization
        for rule=1:9
           g(rule)=sum(beta(rule,:))/sum(beta(:));
        end
        for j=1:point-2
          %prepare A?y
           A(j,:,ite)=[g(1) y(j)*g(1) y(j+1)*g(1) g(2) y(j)*g(2) y(j+1)*g(2) g(3) y(j)*g(3) y(j+1)*g(3) g(4) y(j)*g(4) y(j+1)*g(4) g(5) y(j)*g(5) y(j+1)*g(5) g(6) y(j)*g(6) y(j+1)*g(6) g(7) y(j)*g(7) y(j+1)*g(7) g(8) y(j)*g(8) y(j+1)*g(8) g(9) y(j)*g(9) y(j+1)*g(9)];
           output(j,1)=A(j,:,ite)*the(:,:,i);
        end
           

        
        b=A(:,:,ite)';

        for k=0:point-3
            P(:,:,i)=P(:,:,i)-(P(:,:,i)*b(:,k+1)*b(:,k+1)'*P(:,:,i))/(1+b(:,k+1)'*P(:,:,i)*b(:,k+1));
            the(:,:,i)=the(:,:,i)+P(:,:,i)*b(:,k+1)*(y(k+3)-b(:,k+1)'*the(:,:,i));
        end
       %new_yHead(output)
        for j=1:point-2
           output(j,1)=A(j,:,ite)*the(:,:,i);  %y 
          %caculate error
           e(j)=(y(j+2)-output(j,1))^2; % target-yHead
        end
       %mse index
        rmse(i)=sqrt(sum(e)/(point-2));
         
        %pbest
        if rmse(i)<pbest(i)
            swarmPbest(i,:)=swarm(i,:);     %update pbest position
            pbest(i)=rmse(i);               %update pbest pbest mse index
        end
       %gbest
        if pbest(i)<gbestDistance
            gbest=i;                    %update which one is gbest
            gbestDistance=pbest(i);          %update distance of gbest
        end
        
        %update velocity
        AA=inertia*velocity(i,:);%w
        BB=correction_factor*rand(1)*(swarmPbest(i,:)-swarm(i,:));%pbest
        CC=correction_factor*rand(1)*(swarm(gbest,:) - swarm(i,:));%gbest
        velocity(i,:)=AA+BB+CC;

    end
    
    plotRMSE(ite) = gbestDistance;
end


%% result
% OUTPUT and Target
    figure(1);
    x=linspace(x(3),x(point),point-2);
    beta=[];
       for j=1:point-2
          %IFpart(Rule)
           beta(1,j)=gaussmf(y(j),swarm(gbest,1:2))*gaussmf(y(j+1),swarm(gbest,7:8));
           beta(2,j)=gaussmf(y(j),swarm(gbest,1:2))*gaussmf(y(j+1),swarm(gbest,9:10));
           beta(3,j)=gaussmf(y(j),swarm(gbest,1:2))*gaussmf(y(j+1),swarm(gbest,11:12));
           beta(4,j)=gaussmf(y(j),swarm(gbest,3:4))*gaussmf(y(j+1),swarm(gbest,7:8));
           beta(5,j)=gaussmf(y(j),swarm(gbest,3:4))*gaussmf(y(j+1),swarm(gbest,9:10));
           beta(6,j)=gaussmf(y(j),swarm(gbest,3:4))*gaussmf(y(j+1),swarm(gbest,11:12));
           beta(7,j)=gaussmf(y(j),swarm(gbest,5:6))*gaussmf(y(j+1),swarm(gbest,7:8));
           beta(8,j)=gaussmf(y(j),swarm(gbest,5:6))*gaussmf(y(j+1),swarm(gbest,9:10));
           beta(9,j)=gaussmf(y(j),swarm(gbest,5:6))*gaussmf(y(j+1),swarm(gbest,11:12));
       end
          %THENpart
           for rule=1:9
               g(rule)=sum(beta(rule,:))/sum(beta(:));
           end
       for j=1:point-2
          %new_yHead(output)
           A(j,:,ite)=[g(1) y(j)*g(1) y(j+1)*g(1) g(2) y(j)*g(2) y(j+1)*g(2) g(3) y(j)*g(3) y(j+1)*g(3) g(4) y(j)*g(4) y(j+1)*g(4) g(5) y(j)*g(5) y(j+1)*g(5) g(6) y(j)*g(6) y(j+1)*g(6) g(7) y(j)*g(7) y(j+1)*g(7) g(8) y(j)*g(8) y(j+1)*g(8) g(9) y(j)*g(9) y(j+1)*g(9)];
           output1(j,1)=A(j,:,ite)*the(:,1,gbest);  %y 
       end
       % Learning Curve log
        figure(2)
        semilogy(plotRMSE)
        legend('Learning Curve');
        xlabel('iterations');
        ylabel('semilogy(rmse)');
        
       % Learning Curve  
        figure(5)
        plot(1:maxIter,plotRMSE,'x')
        legend('Learning Curve');
        xlabel('iterations');
        ylabel('rmse');
        
        figure(1)
        plot(x,output1,'--');
        xlabel('X');
        ylabel('Y');
        legend('target','model output');


       % afterPlot;

toc
min(plotRMSE)