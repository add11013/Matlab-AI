clear;
close all;
clc;
tic
TAIEX;
%% substractive clustering
h1=y(1:point-2);
h2=y(2:point-1);
h1std=std(h1);
h2std=std(h2);
h1Center=subclust(h1,0.3);
h2Center=subclust(h2,0.3);
%% formation matrix
count=1;
for i=1:length(h1Center)
    for ii=1:length(h2Center)
        formationMatrix(count,1)=i;
        formationMatrix(count,2)=ii;
        count=count+1;
    end
end
PrePara=(length(h1Center)+length(h2Center))*2;

%% firing strength
for i=1:point-2
    for rule=1:length(formationMatrix)
        beta(rule,i)=gaussmf(h1(i),[h1Center(formationMatrix(rule,1)),std(h1)])*gaussmf(h2(i),[h2Center(formationMatrix(rule,2)),std(h2)]);
    end
end

%% treshold
bb=1;
delFor=0;
for rule=1:length(formationMatrix)
    treshold=0.3*std(reshape(beta,length(formationMatrix)*(point-2),1));
    if std(beta(rule,:))<treshold
        bye(bb)=rule;
        bb=bb+1;
        delFor=1;
    end
end
if delFor==1
    bb=1;
    i=bye(bb);
    formationMatrix(i,:)=[];
    bye(bb)=[];
    while length(bye)~=0
        i=bye(bb);
        formationMatrix(i-1,:)=[];
        bye(bb)=[];
    end
end

%% PSO initialization
swarm_size = 64;                       % number of the swarm particles
maxIter = 30;                          % maximum number of iterations
inertia = 0.8;                         % W
correction_factor = 2.0;               % c1,c2

%% initialize parameters
for i=1:swarm_size
    % Premise parameters
    for ii=1:PrePara
        swarm(i).Position(ii)=randn*yMean*1000;
    end
        swarm(i).pBestPosition=swarm(i).Position;
    count=1;
    % Consequence parameters
    for rule=1:length(formationMatrix)
        conPara(rule,:)=[0 0 0];
        for jj=1:3
            the(count,1,i)=conPara(rule,jj);
            count=count+1;
        end
    end
    % RLSE iteration
    P(:,:,i)=1e9*eye(3*length(formationMatrix));
end
for i=1:swarm_size
    swarm(i).velocity(1:PrePara)=0;
    swarm(i).pBestDistance=1e20;
end
gBest=1;                               % the best swarm
gBestDistance=1e20;                    % error of the best swarm
gBestPosition=swarm(i).Position;


%% PSO main loop
for ite=1:maxIter
    for i=1:swarm_size
        % move
        swarm(i).Position=swarm(i).velocity+swarm(i).Position;
        Iteration(ite).beta=[];
        for jj=1:point-2
            %Firing Strength
            j1=1;
            for number=1:PrePara/4
                temp=[swarm(i).Position(j1:j1+1)];
                termSet{1}(number)={temp};
                j1=j1+2;
            end
            for number=1:PrePara/4
                temp=[swarm(i).Position(j1:j1+1)];
                termSet{2}(number)={temp};
                j1=j1+2;
            end
            for rule=1:length(formationMatrix)
                Iteration(ite).beta(rule,jj)=gaussmf(h1(jj),termSet{1}{formationMatrix(rule,1)})*gaussmf(h2(jj),termSet{2}{formationMatrix(rule,2)});
            end
        end
        %Normalization
        for rule=1:length(formationMatrix)
            g(rule)=sum(Iteration(ite).beta(rule,:))/sum(Iteration(ite).beta(:));
        end
        for jj=1:point-2
            SS=[];DD=[];
            for k=1:length(formationMatrix)
                S=[g(k) g(k) g(k)];
                SS=[SS S];
                D=[1 y(jj) y(jj+1)];
                DD=[DD D];
            end
            A(jj,:)=DD.*SS;
        end

        b=transpose(A);

        for k=0:point-3
            P(:,:,i)=P(:,:,i)-(P(:,:,i)*b(:,k+1)*b(:,k+1)'*P(:,:,i))/(1+b(:,k+1)'*P(:,:,i)*b(:,k+1));
            the(:,:,i)=the(:,:,i)+P(:,:,i)*b(:,k+1)*(y(k+3)-b(:,k+1)'*the(:,:,i));
        end
        %new_yHead(output)
        for jj=1:point-2
            output(jj,1)=A(jj,:)*the(:,:,i);  %y
            %caculate error
            e(jj)=(y(jj+2)-output(jj,1))^2; % target-yHead
        end

        %mse index
        swarm(i).Iteration(ite).rmse=sqrt(sum(e)/(point-2));

        %pbest
        if swarm(i).Iteration(ite).rmse<swarm(i).pBestDistance
            swarm(i).pBestPosition=swarm(i).Position;        %update pbest position
            swarm(i).pBestDistance=swarm(i).Iteration(ite).rmse;               %update pbest pbest mse index
        end
        %gbest
        if swarm(i).Iteration(ite).rmse<gBestDistance
            gBest=i;                                         %update which one is gbest
            gBestDistance=swarm(i).Iteration(ite).rmse;         %update distance of gbest
            gBestPosition=swarm(i).Position;
        end
        %update velocity
        AA=inertia*swarm(i).velocity;%w
        BB=correction_factor*rand(1)*(swarm(i).pBestPosition-swarm(i).Position);%pbest
        CC=correction_factor*rand(1)*(gBestPosition - swarm(i).Position);%gbest
        swarm(i).velocity=AA+BB+CC;
    end

    plotRMSE(ite) = gBestDistance;
end


%% result
% OUTPUT and Target
figure(1);
x=linspace(x(3),x(point),point-2);
beta=[];
for jj=1:point-2
    %IFpart(Rule)
    j1=1;
    for number=1:PrePara/4
        temp=[swarm(gBest).Position(j1:j1+1)];
        termSet{1}(number)={temp};
        j1=j1+2;
    end
    for number=1:PrePara/4
        temp=[swarm(gBest).Position(j1:j1+1)];
        termSet{2}(number)={temp};
        j1=j1+2;
    end
    for rule=1:length(formationMatrix)
        beta(rule,jj)=gaussmf(h1(jj),termSet{1}{formationMatrix(rule,1)})*gaussmf(h2(jj),termSet{2}{formationMatrix(rule,2)});
    end
end
%new_yHead(output)
for rule=1:length(formationMatrix)
    g(rule)=sum(beta(rule,:))/sum(beta(:));
end
for jj=1:point-2
    SS=[];DD=[];
    for k=1:length(formationMatrix)
        S=[g(k) g(k) g(k)];
        SS=[SS S];
        D=[1 y(jj) y(jj+1)];
        DD=[DD D];
    end
    A(jj,:)=DD.*SS;
    output1(jj,1)=A(jj,:)*the(:,:,gBest);  %y
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

% x=linspace(point+2,allpoint+1,testPoint);
% beta=[];
% testh1=y(point-1:allpoint-2);
% testh2=y(point:allpoint-1);
% for jj=1:testPoint
%     %IFpart(Rule)
%     j1=1;
%     for number=1:PrePara/4
%         temp=[swarm(gBest).Position(j1:j1+1)];
%         termSet{1}(number)={temp};
%         j1=j1+2;
%     end
%     for number=1:PrePara/4
%         temp=[swarm(gBest).Position(j1:j1+1)];
%         termSet{2}(number)={temp};
%         j1=j1+2;
%     end
%     beta=[];
%     for rule=1:length(formationMatrix)
%         beta(rule,jj)=gaussmf(testh1(jj),termSet{1}{formationMatrix(rule,1)})*gaussmf(testh2(jj),termSet{2}{formationMatrix(rule,2)});
%     end
% end
% %new_yHead(output)
% for rule=1:length(formationMatrix)
%     g(rule)=sum(beta(rule,:))/sum(beta(:));
% end
% for jj=1:testPoint
%     SS=[];DD=[];
%     for k=1:length(formationMatrix)
%         S=[g(k) g(k) g(k)];
%         SS=[SS S];
%         D=[1 y(point+jj-1) y(point+jj)];
%         DD=[DD D];
%     end
%     A(jj,:)=DD.*SS;
%     output2(jj,1)=A(jj,:)*the(:,:,gBest);  %y
% end
% plot(x,output2,'r--');


toc
