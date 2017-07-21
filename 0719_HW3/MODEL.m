clear
close all;
clc
tic
OriginalData=xlsread('Data_set.csv');
[FeatureIndex DataMatrix]=FeatureSelection(OriginalData);
%% get  Training data
%NumberOfTarget指的是實數型態的目標個數
NumberOfTarget=size(OriginalData,2);
NumberOfTrainPoint=200;
%get h1~hM
for M=1:length(FeatureIndex)
    h(M).value=DataMatrix(1:NumberOfTrainPoint,FeatureIndex(M));
    % substractive clustering for premise fuzzysets
    h(M).center=subclust(h(M).value,0.3);
    h(M).std=std(h(M).value);
end

figure(1)
hold on
%30天漲跌，預測目標是第31天~最後一天的漲跌，也就是最後要判斷第32天~最後一天的實際數值(不是漲跌)
x=linspace(1,length(OriginalData)-31,length(OriginalData)-31);

%畫出每個目標
for i=1:NumberOfTarget
	plot(x,OriginalData(32:length(OriginalData),i));
end

%% prepare target
NumberOfINPUT=length(h);
%NumberOfOUTPUT是指複數型態目標的個數，所以為實數型態除以2
NumberOfOUTPUT=NumberOfTarget/2;

%目標起始行數
k=61;
for N=1:NumberOfOUTPUT
    realPartOfTrain=DataMatrix(1:NumberOfTrainPoint,k);
    imagPartOfTrain=DataMatrix(1:NumberOfTrainPoint,k+1);
    k=k+2;
    y(N).value=realPartOfTrain+imagPartOfTrain*j;
end


%% caculate NumberOfCons
%合併所有h，計算要分幾群之後再用FCM
TMP0=[];
for M=1:NumberOfINPUT
    TMP=h(M).value;
    TMP0=[TMP0;TMP];
end
TotalINPUT=TMP0;
%Number Of Consequence
NumberOfCons=length(subclust(TotalINPUT,0.3));

%% Cons. fuzzyset parameters
%用FCM分群得到後艦部中心和標準差
for N=1:NumberOfOUTPUT
    ConsCenter=fcm(y(N).value,NumberOfCons);
    ConsStd=std(y(N).value);
    y(N).mean=mean(y(N).value);
    y(N).std=std(y(N).value);
end

%% Consequences
%計算每個OUTPUT的後鑑部中心和標準差
        for N=1:NumberOfOUTPUT
            for Q=1:NumberOfCons
                C(N).q(Q)=ConsCenter(Q);
                S(N).q(Q)=ConsStd;
            end
        end
        
%% formation matrix
%建造一個潛艦部的fuzzyset索引，每一列代表一條規則
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
%累加每個前艦部的參數得到前艦部參數個數
NumberOfPremiseParameters=0;
for M=1:NumberOfINPUT
    NumberOfPremiseParameters=NumberOfPremiseParameters+length(h(M).center)*2;
end

%% firing strength
%將每個INPUT的資料點帶入算啟動強度
for M=1:NumberOfINPUT
    for rule=1:length(formationMatrix)
        membership=1;
        for jj=1:NumberOfTrainPoint
            temp=gaussmf(h(M).value(jj),[h(M).center(formationMatrix(rule,M)),h(M).std],1);
            membership=membership*temp;
            BetaOfFormationMatrix(rule,jj)=membership;
        end
    end
end

%% cube selection
%全部啟動強度的標準差*3當作門檻值，篩選掉不要的規則
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
            swarm(i).Position(j1)=randn;
            swarm(i).Position(j1+1)=randn;
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
        P0=1e8*eye((NumberOfINPUT+1)*NumberOfCons);

%% main loop
for ite=1:PSO.iterations
  for i=1:PSO.swarm_size
      %Update swarm Position
      swarm(i).Position=swarm(i).Position+swarm(i).Velocity;  
          %將粒子的位子，儲存成termSet，以便後續建造前艦部的fuzzy set
            j1=1;
            for M=1:NumberOfINPUT
                for number=1:length(h(M).center)
                    termSet{M}(number)={[swarm(i).Position(j1:j1+1)]};
                    j1=j1+2;
                end
            end
            
         
         %每個OUTPUT都要算Beta
        for N=1:NumberOfOUTPUT
            Beta(N).value=[];
            %算每一條規則的啟動強度
            for jj=1:NumberOfTrainPoint
                for rule=1:length(formationMatrix)
                    membership=1;
                    for M=1:NumberOfINPUT
                        r=gaussmf(h(M).value(jj),termSet{M}{formationMatrix(rule,M)},1);
                        theata1Ofh=gaussmf(h(M).value(jj),termSet{M}{formationMatrix(rule,M)},3); %dr/dx
                        theata2Ofh=gaussmf(h(M).value(jj),termSet{M}{formationMatrix(rule,M)},6); %d2r/dx^2
                        temp=r*exp(j*(theata1Ofh+theata2Ofh));
                        membership=membership*temp;
                        Beta(N).value(rule,jj)=membership;
                    end
                end
            end
        end
        
        
        for N=1:NumberOfOUTPUT
            %把每個beta裡的規則分開儲存
            for K=1:NumberOfPremise
                B(N).k(K).value=Beta(N).value(K,:);
            end
        end

        %轉換箭靶中心
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

      %算Q個P
        for Q=1:NumberOfCons
            for jj=1:NumberOfTrainPoint
                %CaculateB
                BOfLambdaTMP0=[];
                for N=1:NumberOfOUTPUT
                    TMP0=[];
                    for K=1:NumberOfPremise
                        TMP=[B(N).k(K).value(jj)];
                        TMP0=[TMP0 TMP];
                    end
                    BOfLambdaTMP=[TMP0];
                    BOfLambdaTMP0=[BOfLambdaTMP0; BOfLambdaTMP];
                end
                BOfLambda=BOfLambdaTMP0;
                
                %CaculateL
                LOfLambdaTMP0=[];
                for K=1:NumberOfPremise
                    TMP0=[];
                    for N=1:NumberOfOUTPUT
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
                    %TMP0=[1 h1 h2 ... hM]
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
        
        %
        TMP0=[];
        for Q=1:NumberOfCons
            TMP=P.q(Q).value;
            TMP0=[TMP0 TMP];
        end
        swarm(i).RLSE.A=TMP0;

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
          
      %new_yHead(output)
      for jj=1:NumberOfTrainPoint
        for N=1:NumberOfOUTPUT
            yHead=swarm(i).RLSE.A(jj,:)*swarm(i).RLSE.iteration(k).theata;  %y
            swarm(i).yHead(jj,N)=yHead(N,1);
           %caculate error
            e(jj,N)=(y(N).value(jj)-swarm(i).yHead(jj,N))*conj(y(N).value(jj)-swarm(i).yHead(jj,N));  % target-yHead
        end
      end
      %累加每一個OUTPUT的rmse當作rmse
      temp0=0;
      for N=1:NumberOfOUTPUT
        temp=sqrt(sum(e(:,N))/(NumberOfTrainPoint));
        temp0=temp0+temp;
        swarm(i).rmse=temp0;
      end
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
            PSO.gBestyHead=swarm(i).yHead;
        end

      %update velocity
      swarm(i).Velocity=PSO.w*swarm(i).Velocity+PSO.c1*PSO.s1*(swarm(i).pBestPosition-swarm(i).Position)+PSO.c2*PSO.s2*(PSO.gBestPosition-swarm(i).Position);
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

      figure(1);
        x=linspace(1,NumberOfTrainPoint,NumberOfTrainPoint);
        %目標為第31天的漲跌，所以 第31天價格+第31天漲跌(預測出的)=第32天價格(預測出的)
        k=1;
        for N=1:NumberOfOUTPUT
            output=OriginalData(31:30+NumberOfTrainPoint,k)+real(PSO.gBestyHead(:,N));
            plot(x,output);
            output=OriginalData(31:30+NumberOfTrainPoint,k+1)+imag(PSO.gBestyHead(:,N));
            plot(x,output);
            k=k+2;
        end
        
        legend('IBM','TSMC','OUTPUT1-real','OUTPUT1-imag')
        toc

