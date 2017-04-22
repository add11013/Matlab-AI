clear
close all;
clc
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
numberOfPrePara=(length(h1Center)+length(h2Center))*2;
numberOfParaPerSpecies=4;
numberOfSpecies=numberOfPrePara/numberOfParaPerSpecies;

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


%% PSO parameters
  PSO.w=0.8;
  PSO.c1=2;
  PSO.c2=2;
  PSO.s1=rand(1);
  PSO.s2=rand(1);
  PSO.iterations=20;
  PSO.GlobalBestDistance=1e70;
  
  
  %initialize the particles
  for k=1:numberOfSpecies
      PSO.species(k).swarm_size=64;
      for i=1:PSO.species(k).swarm_size
        for ii=1:numberOfParaPerSpecies
          PSO.species(k).swarm(i).Position(ii)=randn*yMean*10000;
        end
        PSO.species(k).swarm(i).Velocity(1:numberOfParaPerSpecies)=0;
        PSO.species(k).swarm(i).pBestPosition=PSO.species(k).swarm(i).Position;
        PSO.species(k).swarm(i).pBestDistance=1e70;
      end
      PSO.species(k).gBestPosition=PSO.species(k).swarm(1).Position;
      PSO.species(k).gBestDistance=1e70;
  end
  TMP1=[];
  for kkk=1:numberOfSpecies
        TMP=[PSO.species(kkk).swarm(1).Position];                      
        TMP1=[TMP1 TMP];
  end
  PSO.GlobalBestPosition=TMP1;
  
%% RLSE parameters
numberOfConPara=3*length(formationMatrix);
for k=1:numberOfSpecies
    for i=1:PSO.species(k).swarm_size
        PSO.species(k).swarm(i).RLSE.theta(1:numberOfConPara,1)=0;
        PSO.species(k).swarm(i).RLSE.P=1e9*eye(numberOfConPara);
    end
end

%% main loop
for ite=1:PSO.iterations
  for kk=1:numberOfSpecies
    for i=1:PSO.species(kk).swarm_size
      %move
      PSO.species(kk).swarm(i).Position=PSO.species(kk).swarm(i).Position+PSO.species(kk).swarm(i).Velocity;
      Iteration(ite).beta=[];
        for jj=1:point-2
            %Firing Strength
            j1=1;
            TMP1=[];
            for kkk=1:numberOfSpecies
                if kkk==kk
                  TMP=[PSO.species(kkk).swarm(i).Position];  
                else
                  TMP=[PSO.species(kkk).gBestPosition];                     
                end
                    TMP1=[TMP1 TMP];
            end
            swarmPosition=TMP1;
            
            for number=1:numberOfPrePara/4
                termSet{1}(number)={[swarmPosition(j1:j1+1)]};
                j1=j1+2;
            end
            for number=1:numberOfPrePara/4
                termSet{2}(number)={swarmPosition(j1:j1+1)};
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
            TMP0=[];
            for k=1:length(formationMatrix)
                TMP=[g(k) g(k)*y(jj) g(k)*y(jj+1)];
                TMP0=[TMP0 TMP];
            end
             PSO.species(kk).swarm(i).RLSE.A(jj,:)=TMP0;
        end
        b=transpose(PSO.species(kk).swarm(i).RLSE.A);
        for k=0:(point-2)-1
            PSO.species(kk).swarm(i).RLSE.P=PSO.species(kk).swarm(i).RLSE.P-(PSO.species(kk).swarm(i).RLSE.P*b(:,k+1)*transpose(b(:,k+1))*PSO.species(kk).swarm(i).RLSE.P)/(1+transpose(b(:,k+1))*PSO.species(kk).swarm(i).RLSE.P*b(:,k+1));
            PSO.species(kk).swarm(i).RLSE.theta=PSO.species(kk).swarm(i).RLSE.theta+PSO.species(kk).swarm(i).RLSE.P*b(:,k+1)*(y(k+3)-transpose(b(:,k+1))*PSO.species(kk).swarm(i).RLSE.theta);
        end
      %new_yHead(output)
        for jj=1:point-2
            swarm(i).yHead(jj,1)=PSO.species(kk).swarm(i).RLSE.A(jj,:)*PSO.species(kk).swarm(i).RLSE.theta;  %y
           %caculate error
            e(jj,1)=(y(jj+2)-swarm(i).yHead(jj,1))^2;  % target-yHead
        end
      %mse index
        PSO.species(kk).swarm(i).rmse=sqrt(sum(e)/(point-2));
      %pbest
        if PSO.species(kk).swarm(i).rmse<PSO.species(kk).swarm(i).pBestDistance
            PSO.species(kk).swarm(i).pBestPosition=PSO.species(kk).swarm(i).Position;        %update pbest position
            PSO.species(kk).swarm(i).pBestDistance=PSO.species(kk).swarm(i).rmse;            %update pbest pbest mse index
        end
      %gbest
        if PSO.species(kk).swarm(i).rmse<PSO.species(kk).gBestDistance
            PSO.species(kk).gBest=i;                             %update which one is gbest
            PSO.species(kk).gBestDistance=PSO.species(kk).swarm(i).rmse;         %update distance of gbest
            PSO.species(kk).gBestPosition=PSO.species(kk).swarm(i).Position;  
        end
       %GlobalBestPosition
        if PSO.species(kk).swarm(i).rmse<PSO.GlobalBestDistance
            PSO.GlobalBestPosition=swarmPosition;
            PSO.GlobalBestDistance=PSO.species(kk).swarm(i).rmse;
            PSO.GlobalBestSpecies=kk;
            PSO.GlobalBestSwarm=i;
            PSO.GlobalBestYhead=swarm(i).yHead;
        end

      %update velocity
      PSO.species(kk).swarm(i).Velocity=PSO.w*PSO.species(kk).swarm(i).Velocity+PSO.c1*PSO.s1*(PSO.species(kk).swarm(i).pBestPosition-PSO.species(kk).swarm(i).Position)+PSO.c2*PSO.s2*(PSO.species(kk).gBestPosition-PSO.species(kk).swarm(i).Position);
    end
  end
  PSO.plotRMSE(ite) = PSO.GlobalBestDistance;
end

%% result
% OUTPUT and Target
      figure(2)
      subplot(1,2,1)
          semilogy(PSO.plotRMSE);
          legend('Learning Curve');
          xlabel('iterations');
          ylabel('semilogy(rmse)');
      subplot(1,2,2)
          plot(1:PSO.iterations,PSO.plotRMSE,'x');
          legend('Learning Curve');
          xlabel('iterations');
          ylabel('rmse');
      figure(1);
        x=linspace(x(3),x(point),point-2);
        plot(x,PSO.GlobalBestYhead,'--');
%% test
        x=linspace(point+2,allpoint+1,testPoint);
        beta=[];
        testh1=y(point-1:allpoint-2);
        testh2=y(point:allpoint-1);
        for jj=1:testPoint
            %IFpart(Rule)
            j1=1;
            for number=1:numberOfPrePara/4
                termSet{1}(number)={[PSO.GlobalBestPosition(j1:j1+1)]};
                j1=j1+2;
            end
            for number=1:numberOfPrePara/4
                termSet{2}(number)={PSO.GlobalBestPosition(j1:j1+1)};
                j1=j1+2;
            end
            beta=[];
            for rule=1:length(formationMatrix)
                beta(rule,jj)=gaussmf(testh1(jj),termSet{1}{formationMatrix(rule,1)})*gaussmf(testh2(jj),termSet{2}{formationMatrix(rule,2)});
            end
        end
        
        %new_yHead(output)
        for rule=1:length(formationMatrix)
            g(rule)=sum(beta(rule,:))/sum(beta(:));
        end
        for jj=1:testPoint
            TMP1=[];
            for k=1:length(formationMatrix)
                TMP=[g(k) g(k)*y(point+jj-1) g(k)*y(point+jj)];
                TMP1=[TMP1 TMP];
            end
            A(jj,:)=TMP1;
            output2(jj,1)=A(jj,:)*PSO.species(PSO.GlobalBestSpecies).swarm(PSO.GlobalBestSwarm).RLSE.theta;  %y
        end
        for jj=1:testPoint
            PSO.test.e(jj)=(y(jj+point-1)-output2(jj,1))^2;
        end
            PSO.test.rmse=sqrt(sum(PSO.test.e)/(testPoint))
        plot(x,output2,'r--');          

toc
