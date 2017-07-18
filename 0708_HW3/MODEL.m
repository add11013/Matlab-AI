clear
close all;
clc
tic
OriginalData=xlsread('Data_set.csv');
FeatureIndex=FeatureSelection(OriginalData);
%% get  Training data
%NumberOfTarget指的是實數型態的目標個數
NumberOfTarget=size(OriginalData,2);
for t=1:NumberOfTarget
    tsmc=OriginalData(:,t);
    LengthOfData=length(tsmc);
    Updown=31;
    for jj=1:Updown-1
        k=jj;
        for i=1:LengthOfData-Updown
            TMP(i,jj)=tsmc(k);
            k=k+1;
        end
    end
    data(t).value=TMP;
end

AllData=[ ];
%data.value最後一行是目標不用取，所以取1:Updown-1
for t=1:NumberOfTarget
    TMP=data(t).value(:,1:Updown-1);
    AllData=[AllData TMP];
end

%get h1~hM
for M=1:length(FeatureIndex)
    h(M).value=AllData(:,FeatureIndex(M));
    % substractive clustering for premise fuzzysets
    h(M).center=subclust(h(M).value,0.3);
    h(M).std=std(h(M).value);
end
NumberOfTrainPoint=length(h(1).value);
figure(1)
hold on
%% prepare target
NumberOfINPUT=length(h);
%NumberOfOUTPUT是指複數型態目標的個數，所以為實數型態除以2
NumberOfOUTPUT=NumberOfTarget/2;
k=1;
for N=1:NumberOfOUTPUT
    realPart=OriginalData(Updown+1:length(OriginalData),k);
    imgPart=OriginalData(Updown+1:length(OriginalData),k+1);
    x=linspace(1,length(realPart),length(realPart));
    plot(x,realPart);
    plot(x,imgPart);
    k=k+2;
    
    y(N).value=realPart+imgPart*j;
end


%% caculate NumberOfCons
TMP0=[];
for M=1:NumberOfINPUT
    TMP=h(M).value;
    TMP0=[TMP0;TMP];
end
TotalINPUT=TMP0;
%Number Of Consequence
NumberOfCons=length(subclust(TotalINPUT,0.3));

%% Cons. fuzzyset parameters
for N=1:NumberOfOUTPUT
    ConsCenter=fcm(y(N).value,NumberOfCons);
    ConsStd=std(y(N).value);
    y(N).mean=mean(y(N).value);
    y(N).std=std(y(N).value);
end

%% Consequences
        for N=1:NumberOfOUTPUT
            for Q=1:NumberOfCons
                C(N).q(Q)=ConsCenter(Q);
                S(N).q(Q)=ConsStd;
            end
        end
%% formation matrix
NumberOfRule=1;
for M=1:NumberOfINPUT
    NumberOfRule=NumberOfRule*length(h(M).center);
end
xxx=1;
yyy=NumberOfRule;
for M=1:NumberOfINPUT
    count=1;
    xxx=xxx*length(h(M).center);
    yyy=yyy/length(h(M).center);
    for i=1:xxx
        for ii=1:yyy
            if mod(i,length(h(M).center))==0
                k=length(h(M).center);
            else
                k=mod(i,length(h(M).center));
            end
            formationMatrix(count,M)=k;
            count=count+1;
        end
    end
end

% caculate Number Of Premise Parameters
NumberOfPremiseParameters=0;
for M=1:NumberOfINPUT
    NumberOfPremiseParameters=NumberOfPremiseParameters+length(h(M).center)*2;
end

%% firing strength
for jj=1:NumberOfTrainPoint
    for rule=1:length(formationMatrix)
        membership=1;
        for M=1:NumberOfINPUT
            temp=gaussmf(h(M).value(jj),[h(M).center(formationMatrix(rule,M)),h(M).std],1);
            membership=membership*temp;
            BetaOfFormationMatrix(rule,jj)=membership;
        end
    end
end

%% cube selection
bb=1;
delFor=0;
for rule=1:length(formationMatrix)
    treshold=0.3*std(reshape(BetaOfFormationMatrix,length(formationMatrix)*(NumberOfTrainPoint),1));
    if std(BetaOfFormationMatrix(rule,:))<treshold
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
    k=1;
    while length(bye)~=0
        i=bye(bb);
        formationMatrix(i-k,:)=[];
        k=k+1;
        bye(bb)=[];
    end
end
NumberOfPremise=length(formationMatrix);

%% PSO parameters
  PSO.w=0.8;
  PSO.c1=2;
  PSO.c2=2;
  PSO.s1=rand(1);
  PSO.s2=rand(1);
  PSO.swarm_size=64;
  PSO.iterations=30;
  %initialize the particles
  for i=1:PSO.swarm_size
    j1=1;
    for M=1:NumberOfINPUT
        for ii=1:length(h(M).center)
            swarm(i).Position(j1)=randn*h(M).center(ii);
            swarm(i).Position(j1+1)=randn*h(M).std;
            j1=j1+2;
        end
    end
    swarm(i).Velocity(1:NumberOfPremiseParameters)=0;
    swarm(i).pBestPosition=swarm(i).Position;
    swarm(i).pBestDistance=1e12;
  end
  PSO.gBestPosition=swarm(1).Position;
  PSO.gBestDistance=1e12;
  
  
%% RLSE parameters
        theata0(1:(NumberOfINPUT+1)*NumberOfCons,1)=0;%
        P0=1e10*eye((NumberOfINPUT+1)*NumberOfCons);

%% main loop
for ite=1:PSO.iterations
  for i=1:PSO.swarm_size
      %move
      swarm(i).Position=swarm(i).Position+swarm(i).Velocity;
      Iteration(ite).beta=[];
        for jj=1:NumberOfTrainPoint
            %Firing Strength
            j1=1;
            for M=1:NumberOfINPUT
                for number=1:length(h(M).center)
                    termSet{M}(number)={[swarm(i).Position(j1:j1+1)]};
                    j1=j1+2;
                end
            end

%             for rule=1:length(formationMatrix)
%                 r1=gaussmf(h1(jj),termSet{1}{formationMatrix(rule,1)},1);
%                 r2=gaussmf(h2(jj),termSet{2}{formationMatrix(rule,2)},1);
%                 theata1Ofh1=gaussmf(h1(jj),termSet{1}{formationMatrix(rule,1)},3);
%                 theata2Ofh1=gaussmf(h1(jj),termSet{1}{formationMatrix(rule,1)},6);
%                 theata1Ofh2=gaussmf(h2(jj),termSet{2}{formationMatrix(rule,2)},3);
%                 theata2Ofh2=gaussmf(h2(jj),termSet{2}{formationMatrix(rule,2)},6);               
%                 Iteration(ite).beta(rule,jj)=r1*exp(j*(theata1Ofh1+theata2Ofh1))*r2*exp(j*(theata1Ofh2+theata2Ofh2));
%             end
            for rule=1:length(formationMatrix)
                membership=1;
                for M=1:NumberOfINPUT
                    r=gaussmf(h(M).value(jj),termSet{M}{formationMatrix(rule,M)},1);
                    theata1Ofh=gaussmf(h(M).value(jj),termSet{M}{formationMatrix(rule,M)},3); %dr/dx
                    theata2Ofh=gaussmf(h(M).value(jj),termSet{M}{formationMatrix(rule,M)},6); %d2r/dx^2
                    temp=r*exp(j*(theata1Ofh+theata2Ofh));
                    membership=membership*temp;
                    Iteration(ite).beta(rule,jj)=membership;
                end
            end
        end
        for K=1:NumberOfPremise
            B(1).k(K).value=Iteration(ite).beta(K,:);
        end

        for N=1:NumberOfOUTPUT
            for Q=1:NumberOfCons
                        aocC(N).q(Q)=exp(-(C(N).q(Q)-y(N).mean)^2/(2*y(N).std^2))  *exp(j*exp(-(C(N).q(Q)-y(N).mean)^2/(2*y(N).std^2))* (-(C(N).q(Q)-y(N).mean)/(y(N).std^2)));
                        aocS(N).q(Q)=exp(-(S(N).q(Q)^2)/(2*y(N).std^2))*exp(j*exp(-(S(N).q(Q)^2)/(2*y(N).std^2))  *(-S(N).q(Q))/(y(N).std^2));
                    for K=1:NumberOfPremise
                         f1=exp(-(B(N).k(K).value-aocC(N).q(Q)).*conj(B(N).k(K).value-aocC(N).q(Q))./(2.*aocS(N).q(Q).*conj(aocS(N).q(Q))));
                         lambda(N).k(K).q(Q).value=f1.*exp(j.*f1.*-(B(N).k(K).value-aocC(N).q(Q))./(((aocS(N).q(Q)).*conj((aocS(N).q(Q))))));
                    end
            end
        end

        for jj=1:NumberOfTrainPoint
            for Q=1:NumberOfCons
                %CaculateB
                BOfLambdaTMP0=[];
                for N=1:NumberOfOUTPUT
                    TMP0=[];
                    for K=1:NumberOfPremise
                        TMP=[B(N).k(K).value(jj)];
                        TMP0=[TMP0 TMP];
                    end
                    BOfLambdaTMP=[TMP0];
                    BOfLambdaTMP0=[BOfLambdaTMP0;BOfLambdaTMP];
                end
                BOfLambda=BOfLambdaTMP0;
                
                %CaculateL
                LOfLambdaTMP0=[];
                for K=1:NumberOfPremise
                    TMP0=[];
                    for N=1:1
                        TMP=[lambda(N).k(K).q(Q).value(jj)];
                        TMP0=[TMP0 TMP];
                    end
                    LOfLambdaTMP=[TMP0];
                    LOfLambdaTMP0=[LOfLambdaTMP0;LOfLambdaTMP];
                end
                LOfLambda=LOfLambdaTMP0;
                
                %CaculateH
                HOfLambdaTMP0=[];
                for N=1:NumberOfOUTPUT
                    TMP0=[1];
                    for M=1:NumberOfINPUT
                        TMP=h(M).value(jj);
                        TMP0=[TMP0 TMP];
                    end
                    HOfLambdaTMP=[TMP0];
                    HOfLambdaTMP0=[HOfLambdaTMP0;HOfLambdaTMP];
                end
                HOfLambda=HOfLambdaTMP0;
                
                P.q(Q).value(jj,:)=[BOfLambda*LOfLambda*HOfLambda];
            end
        end
        TMP0=[];
        for Q=1:NumberOfCons
            TMP=P.q(Q).value;
            TMP0=[TMP0 TMP];
        end
        swarm(i).RLSE.A=TMP0;
%         for jj=1:NumberOfTrainPoint-2
%             TMP0=[];
%             for k=1:length(formationMatrix)
%                 TMP=[g(k) g(k)*y(1).value(jj) g(k)*y(1).value(jj+1)];
%                 TMP0=[TMP0 TMP];
%             end
%              swarm(i).RLSE.A(jj,:)=TMP0;
%         end
        b=transpose(swarm(i).RLSE.A);
        for N=1:NumberOfOUTPUT
            for k=1:(NumberOfTrainPoint)
                if(k==1)
                    swarm(i).RLSE.iteration(k).P=P0-(P0*b(:,k)*transpose(b(:,k))*P0)/(1+transpose(b(:,k))*P0*b(:,k));
                    swarm(i).RLSE.iteration(k).theata=theata0+swarm(i).RLSE.iteration(k).P*b(:,k)*(y(N).value(k)-transpose(b(:,k))*theata0);
                else
                    swarm(i).RLSE.iteration(k).P=swarm(i).RLSE.iteration(k-1).P-(swarm(i).RLSE.iteration(k-1).P*b(:,k)*transpose(b(:,k))*swarm(i).RLSE.iteration(k-1).P)/(1+transpose(b(:,k))*swarm(i).RLSE.iteration(k-1).P*b(:,k));
                    swarm(i).RLSE.iteration(k).theata=swarm(i).RLSE.iteration(k-1).theata+swarm(i).RLSE.iteration(k).P*b(:,k)*(y(N).value(k)-transpose(b(:,k))*swarm(i).RLSE.iteration(k-1).theata);
                end
            end
        end
        
        %bbb  98*12
%         p=eye(9)
%         p_0=1e7*p;
%         q_0=zeros(9,1);
%         for k=1:row
%             if(k==1)
%                 RLSE(k).p=p_0-(p_0*bbb(k,:)'*bbb(k,:)*p_0)/(1+bbb(k,:)*p_0*bbb(k,:)'');
%                 RLSE(k).q=q_0+RLSE(k).p*bbb(k,:)'*(OutputMatrix(k,1)-bbb(k,:)*q_0);
%             else
%                 RLSE(k).p=RLSE(k-1).p-(RLSE(k-1).p*bbb(k,:)'*bbb(k,:)*RLSE(k-1).p)/(1+bbb(k,:)*RLSE(k-1).p*bbb(k,:)');
%                 RSLE(k).q=RLSE(k-1).q+RLSE(k).p*bbb(k,:)'*(OutputMatrix(k,1)-bbb(k,:)*RLSE(k-1).q);
%             end
%         end
%         
      %new_yHead(output)
      for N=1:NumberOfOUTPUT
        for jj=1:NumberOfTrainPoint
            swarm(i).yHead(jj,1)=swarm(i).RLSE.A(jj,:)*swarm(i).RLSE.iteration(k).theata;  %y
           %caculate error
            e(jj,N)=(y(N).value(jj)-swarm(i).yHead(jj,1))*conj(y(N).value(jj)-swarm(i).yHead(jj,1));  % target-yHead
        end
      end
      %rmse index
        swarm(i).rmse=sqrt(sum(e(:,N))/(NumberOfTrainPoint));
      %pbest
        if swarm(i).rmse<swarm(i).pBestDistance
            swarm(i).pBestPosition=swarm(i).Position;        %update pbest position
            swarm(i).pBestDistance=swarm(i).rmse;            %update pbest rmse index
        end
      %gbest
        if swarm(i).rmse<PSO.gBestDistance
            gBest=i;                             %update which one is gbest
            PSO.gBestDistance=swarm(i).rmse;         %update distance of gbest
            PSO.gBestPosition=swarm(i).Position;  
        end

      %update velocity
      swarm(i).Velocity=PSO.w*swarm(i).Velocity+PSO.c1*PSO.s1*(swarm(i).pBestPosition-swarm(i).Position)+PSO.c2*PSO.s2*(swarm(gBest).Position-swarm(i).Position);
  end
  PSO.plotRMSE(ite) = PSO.gBestDistance
  ite
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
      for i=1:PSO.swarm_size
          finalRMSE(i)=swarm(i).rmse;
      end
      gBestRMSE=1e10;
      for i=1:PSO.swarm_size
        if finalRMSE(i)<gBestRMSE
            gBest=i;
            gBestRMSE=finalRMSE(i);
        end
      end
      figure(1);
        x=linspace(1,NumberOfTrainPoint,NumberOfTrainPoint);
        plot(x,real(swarm(gBest).yHead),'--');
        plot(x,imag(swarm(gBest).yHead),'--');
        legend('IBM','TSMC','OUTPUT1-real','OUTPUT1-imag')
        toc

