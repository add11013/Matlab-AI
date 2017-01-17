clear
clc
close all;
%% plot target
figure(1);
hold on
x=linspace(-2,2);
for i=1:100
    y(i)=x(i).^2+10;
end
plot(x,y);
%% consequence parameters
for rule=1:4
    conPara(rule,:)=[rand(1)*10 rand(1)*10 rand(1)*10 ];
end

%% PSO initialization
swarm_size = 64;                       % number of the swarm particles
maxIter = 10;                         % maximum number of iterations
inertia = 0.8;                         % W
correction_factor = 2.0;               % c1,c2
velocity(1:swarm_size,1:8) = 0;       % set initial velocity for particles
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
end
    PlotFuzzyset;
    
%% PSO main loop
for ite=1:maxIter
    for i=1:swarm_size
        % move
       % swarm(i,:)=velocity(i,:)+swarm(i,:);
        
        %model
        for j=1:98
          %IFpart(Rule)
           beta(1,j)=gaussmf(y(j),swarm(i,1:2))*gaussmf(y(j+1),swarm(i,3:4));
           beta(2,j)=gaussmf(y(j),swarm(i,3:4))*gaussmf(y(j+1),swarm(i,5:6));
           beta(3,j)=gaussmf(y(j),swarm(i,5:6))*gaussmf(y(j+1),swarm(i,7:8));
           beta(4,j)=gaussmf(y(j),swarm(i,7:8))*gaussmf(y(j+1),swarm(i,1:2));
          %THENpart
           A(j,:)=[1 y(j) y(j+1) 1 y(j) y(j+1) 1 y(j) y(j+1) 1 y(j) y(j+1)];
           count=1;
           for rule=1:4
               for jj=1:3
                   the(count,1)=conPara(rule,jj);
                   count=count+1;
               end
           end
            
           %yHead(output)
           count=1;
           for rule=1:4
               yHead(rule)=(the(count,1)+the(count+1,1)*y(j)+the(count+2,1)*y(j+1))*beta(rule,j)/sum(beta(:,j));
               count=count+3;         
           end
           output(j,1)=yHead(1)+yHead(2)+yHead(3)+yHead(4);
           %caculate error
           e(j)=(y(j+2)-output(j))^2; % target-yHead
        end
        %mse index
        mse(i)=sum(e)/98;
        
        b=A';
        
        %RLSE iteration
        P=100000000*eye(12);
        for k=1:100
            P=P-(P*b*b'*P)/(1+b'*P*b);
            the=the+P*b*(output-b'*the);
        end
        
    end
end

