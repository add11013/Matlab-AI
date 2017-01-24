clear;
close all;
clc;
tic
target;
%% substractive clustering
h1=y(1:point-2);
h2=y(2:point-1);
h1std=std(h1);
h2std=std(h2);
h1Center=subclust(h1,0.3);
h2Center=subclust(h2,0.3);


%% formation matrix
k=1;
for i=1:length(h1Center)
    for ii=1:length(h2Center)
        formationMatrix(k,1)=i;
        formationMatrix(k,2)=ii;
        k=k+1;
    end
end
PrePara=(length(h1Center)+length(h2Center))*2;

%% PSO initialization
swarm_size = 64;                       % number of the swarm particles
maxIter = 100;                         % maximum number of iterations
inertia = 0.8;                         % W
correction_factor = 2.0;               % c1,c2
velocity(1:swarm_size,1:PrePara) = 0;  % set initial velocity for particles
pbest(1:swarm_size) = 1e9;             % initial pbest distance
gbest=1;                               % the best swarm
gbestDistance=1000;                    % the error of best swarm

%% firing strength
for i=1:point-2
    for rule=1:length(formationMatrix)
        beta(rule,i)=gaussmf(h1(i),[h1Center(formationMatrix(rule,1)),std(h1)])*gaussmf(h2(i),[h2Center(formationMatrix(rule,2)),std(h2)]);
    end
end

%% treshold
bb=1;
for rule=1:length(formationMatrix)
    treshold=0.3*std(reshape(beta,length(formationMatrix)*(point-2),1));
    if std(beta(rule,:))<treshold
        bye(bb)=rule;
        bb=bb+1;
    end    
end
bb=1;
i=bye(bb);
formationMatrix(i,:)=[];
bye(bb)=[];
while length(bye)~=0
    i=bye(bb);
    formationMatrix(i-1,:)=[];
    bye(bb)=[];
end

%% initialize parameters
for i=1:64
   % Premise parameters
    for ii=1:PrePara
        swarm(i,ii)=randn(1)*10+randn(1)*10*j;    
    end
    
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
      P(:,:,i)=10000*eye(3*9);
end


%% PSO main loop
for ite=1:maxIter
    for i=swarm_size 
        beta=[];
        for j=1:point-2
           %Firing Strength
            l=30;
                termSet{1}={[swarm(1:2)],[swarm(3:4)],[swarm(5:6)]};
                termSet{2}={[swarm(7:8)],[swarm(9:10)],[swarm(11:12)]};
            for rule=1:length(formationMatrix)
                beta(rule,j)=ws(h1(j),termSet{1}{formationMatrix(rule,1)},l)*ws(h2(j),termSet{2}{formationMatrix(rule,2)},l);
            end
           %Normalization
            for rule=1:length(formationMatrix)
                g(rule)=sum(beta(rule,:))/sum(beta(:));
            end        
        end
        SS=[];
        for k=1:length(formationMatrix)
                S=[g(k); g(k); g(k);];
                SS=[SS; S];
        end
        
    end
end

toc


