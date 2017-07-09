clear
close all;
clc
tic

%data prepare
temp=xlsread('Data_set.csv');
%M
NumberOfINPUT=2;
%% data1
DataOfTest=temp(0.7*length(temp):length(temp),1);
DataOfTrain=temp(1:0.7*length(temp),1);

NumberOfTestPoint=length(DataOfTest);
NumberOfTrainPoint=length(DataOfTrain);
NumberOfAllPoint=NumberOfTrainPoint+NumberOfTestPoint;

x=linspace(1,NumberOfAllPoint,NumberOfAllPoint);
DATA1=[(DataOfTrain(:,1));(DataOfTest(:,1))];
yMean=mean(DATA1);
figure(1);
hold on
plot(x,DATA1);
% substractive clustering
h1OfDATA1=DATA1(1:NumberOfTrainPoint-2);
h2OfDATA1=DATA1(2:NumberOfTrainPoint-1);
h1CenterOfDATA1=subclust(h1OfDATA1,0.29);
h2CenterOfDATA1=subclust(h2OfDATA1,0.29);

%% data2
DataOfTest=temp(0.7*length(temp):length(temp),2);
DataOfTrain=temp(1:0.7*length(temp),2);

x=linspace(1,NumberOfAllPoint,NumberOfAllPoint);
DATA2=[(DataOfTrain(:,1));(DataOfTest(:,1))];
yMean=mean(DATA2);
plot(x,DATA2);
% substractive clustering
h1OfDATA2=DATA2(1:NumberOfTrainPoint-2);
h2OfDATA2=DATA2(2:NumberOfTrainPoint-1);
h1CenterOfDATA2=subclust(h1OfDATA2,0.29);
h2CenterOfDATA2=subclust(h2OfDATA2,0.29);

%% combine DATA
h1=DATA1(1:NumberOfTrainPoint-2)+j*DATA2(1:NumberOfTrainPoint-2);
h2=DATA1(2:NumberOfTrainPoint-1)+j*DATA2(2:NumberOfTrainPoint-1);
h1Center=h1CenterOfDATA1+j*h1CenterOfDATA2;
h2Center=h2CenterOfDATA1+j*h2CenterOfDATA2;
y(1).value=DATA1+j*DATA2;
y(1).std=std(y(1).value);
y(1).mean=mean(y(1).value);

%% formation matrix
count=1;
for i=1:length(h1Center)
    for ii=1:length(h2Center)
        formationMatrix(count,1)=i;
        formationMatrix(count,2)=ii;
        count=count+1;
    end
end
NumberOfPremiseParameters=(length(h1Center)+length(h2Center))*2;

%% firing strength
for i=1:NumberOfTrainPoint-2
    for rule=1:length(formationMatrix)
        BetaOfFormationMatrix(rule,i)=gaussmf(h1(i),[h1Center(formationMatrix(rule,1)),std(h1)],1)*gaussmf(h2(i),[h2Center(formationMatrix(rule,2)),std(h2)],1);
    end
end
%% Consequences
        for N=1:1
            ConsCenterReal=subclust(real(y(N).value),0.29);
            ConsCenterImag=subclust(imag(y(N).value),0.29);
            NumberOfCons=length(ConsCenterReal);
            for Q=1:NumberOfCons
                C(N).q(Q)=ConsCenterReal(Q)+j*ConsCenterImag(Q);
                S(N).q(Q)=y(N).std;
            end
        end
%% cube selection
bb=1;
delFor=0;
for rule=1:length(formationMatrix)
    treshold=0.3*std(reshape(BetaOfFormationMatrix,length(formationMatrix)*(NumberOfTrainPoint-2),1));
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
    while length(bye)~=0
        i=bye(bb);
        formationMatrix(i-1,:)=[];
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
  PSO.iterations=20;
  %initialize the particles
  for i=1:PSO.swarm_size
    for ii=1:NumberOfPremiseParameters
      swarm(i).Position(ii)=randn*yMean*1000+j*randn*yMean*1000;
    end
    swarm(i).Velocity(1:NumberOfPremiseParameters)=0;
    swarm(i).pBestPosition=swarm(i).Position;
    swarm(i).pBestDistance=1e12;
  end
  PSO.gBestPosition=swarm(1).Position;
  PSO.gBestDistance=1e12;
  
  
%% RLSE parameters
for i=1:PSO.swarm_size
    swarm(i).RLSE.theata(1:(NumberOfINPUT+1)*NumberOfCons,1)=0;
    swarm(i).RLSE.P=1e6*eye((NumberOfINPUT+1)*NumberOfCons);
end

%% main loop
for ite=1:PSO.iterations
  for i=1:PSO.swarm_size
      %move
      swarm(i).Position=swarm(i).Position+swarm(i).Velocity;
      Iteration(ite).beta=[];
        for jj=1:NumberOfTrainPoint-2
            %Firing Strength
            j1=1;
            for number=1:NumberOfPremiseParameters/4
                termSet{1}(number)={[swarm(i).Position(j1:j1+1)]};
                j1=j1+2;
            end
            for number=1:NumberOfPremiseParameters/4
                termSet{2}(number)={swarm(i).Position(j1:j1+1)};
                j1=j1+2;
            end
            for rule=1:length(formationMatrix)
                r1=gaussmf(h1(jj),termSet{1}{formationMatrix(rule,1)},1);
                r2=gaussmf(h2(jj),termSet{2}{formationMatrix(rule,2)},1);
                theata1Ofh1=gaussmf(h1(jj),termSet{1}{formationMatrix(rule,1)},3);
                theata2Ofh1=gaussmf(h1(jj),termSet{1}{formationMatrix(rule,1)},2);
                theata1Ofh2=gaussmf(h2(jj),termSet{2}{formationMatrix(rule,2)},3);
                theata2Ofh2=gaussmf(h2(jj),termSet{2}{formationMatrix(rule,2)},2);               
                Iteration(ite).beta(rule,jj)=r1*exp(j*(theata1Ofh1+theata2Ofh1))*r2*exp(j*(theata1Ofh2+theata2Ofh2));
            end
        end
        for K=1:NumberOfPremise
            B(1).k(K).value=Iteration(ite).beta(K,:);
        end

        for N=1:1
            for K=1:NumberOfPremise
                    for Q=1:NumberOfCons
                        aocC(N).q(Q)=exp(-(C(N).q(Q)-y(N).mean)*conj(C(N).q(Q)-y(N).mean)/(2*y(N).std*conj(y(N).std)))  *exp(j*exp(-(C(N).q(Q)-y(N).mean)*conj(C(N).q(Q)-y(N).mean)  /(2*y(N).std*conj(y(N).std)))* (-(C(N).q(Q)-y(N).mean)/(y(N).std*conj(y(N).std))));
                        aocS(N).q(Q)=exp(-(S(N).q(Q)*conj(S(N).q(Q)))/(2*y(N).std*conj(y(N).std)))*exp(j*exp(-(S(N).q(Q)*conj(S(N).q(Q)))/(2*y(N).std))  *(-S(N).q(Q)*conj(S(N).q(Q)))/(y(N).std*conj(y(N).std)));
                        f1=exp(-(B(N).k(K).value-aocC(N).q(Q)).*conj(B(N).k(K).value-aocC(N).q(Q))./(2.*aocS(N).q(Q).*conj(aocS(N).q(Q))));
                        lambda(N).k(K).q(Q).value=f1.*exp(j.*f1.*-(B(N).k(K).value-aocC(N).q(Q))./(((aocS(N).q(Q)).*conj((aocS(N).q(Q))))));
                    end
            end
        end

        for jj=1:NumberOfTrainPoint-2
            for Q=1:3
                %CaculateB
                BOfLambdaTMP0=[];
                for N=1:1
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
                for N=1:1
                    TMP0=[1];
                    TMP=[y(N).value(jj) y(N).value(jj+1)];
                    TMP0=[TMP0 TMP];
                    HOfLambdaTMP=[TMP0];
                    HOfLambdaTMP0=[HOfLambdaTMP0;HOfLambdaTMP];
                end
                HOfLambda=HOfLambdaTMP0;
                
                P.q(Q).value(jj,:)=[BOfLambda*LOfLambda*HOfLambda];  
            end
        end
        TMP0=[];
        for Q=1:3
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
        for k=0:(NumberOfTrainPoint-2)-1
            swarm(i).RLSE.P=swarm(i).RLSE.P-(swarm(i).RLSE.P*b(:,k+1)*transpose(b(:,k+1))*swarm(i).RLSE.P)/(1+transpose(b(:,k+1))*swarm(i).RLSE.P*b(:,k+1));
            swarm(i).RLSE.theata=swarm(i).RLSE.theata+swarm(i).RLSE.P*b(:,k+1)*(y(1).value(k+3)-transpose(b(:,k+1))*swarm(i).RLSE.theata);
        end
      %new_yHead(output)
        for jj=1:NumberOfTrainPoint-2
            swarm(i).yHead(jj,1)=swarm(i).RLSE.A(jj,:)*swarm(i).RLSE.theata;  %y
           %caculate error
            e(jj,1)=(y(1).value(jj+2)-swarm(i).yHead(jj,1))*conj(y(1).value(jj+2)-swarm(i).yHead(jj,1));  % target-yHead
        end
      %mse index
        swarm(i).rmse=sqrt(sum(e)/(NumberOfTrainPoint-2));
      %pbest
        if swarm(i).rmse<swarm(i).pBestDistance
            swarm(i).pBestPosition=swarm(i).Position;        %update pbest position
            swarm(i).pBestDistance=swarm(i).rmse;            %update pbest pbest mse index
        end
      %gbest
        if swarm(i).rmse<PSO.gBestDistance
            gBest=i;                             %update which one is gbest
            PSO.gBestDistance=swarm(i).rmse;         %update distance of gbest
            PSO.gBestPosition=swarm(i).Position;  
        end

      %update velocity
      swarm(i).Velocity=PSO.w*swarm(i).Velocity+PSO.c1*PSO.s1*(swarm(i).pBestPosition-swarm(i).Position)+PSO.c2*PSO.s2*(PSO.gBestPosition-swarm(i).Position);
  end
  PSO.plotRMSE(ite) = PSO.gBestDistance;
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
        x=linspace(x(3),x(NumberOfTrainPoint),NumberOfTrainPoint-2);
        plot(x,real(swarm(gBest).yHead),'--');
        plot(x,imag(swarm(gBest).yHead),'--');
%% test
testy(1).std=std(y(1).value(NumberOfTrainPoint+1:NumberOfAllPoint));
testy(1).mean=mean(y(1).value(NumberOfTrainPoint+1:NumberOfAllPoint));
        for N=1:1
            ConsCenterReal=subclust(real(y(N).value(NumberOfTrainPoint+1:NumberOfAllPoint)),0.29);
            ConsCenterImag=subclust(imag(y(N).value(NumberOfTrainPoint+1:NumberOfAllPoint)),0.29);
            NumberOfCons=length(ConsCenterReal);
            for Q=1:NumberOfCons
                C(N).q(Q)=ConsCenterReal(Q)+j*ConsCenterImag(Q);
                S(N).q(Q)=testy(N).std;
            end
        end
        x=linspace(NumberOfTrainPoint+2,NumberOfAllPoint+1,NumberOfTestPoint);
        BetaOfTesting=[];
        testh1=y(1).value(NumberOfTrainPoint-1:NumberOfAllPoint-2);
        testh2=y(1).value(NumberOfTrainPoint:NumberOfAllPoint-1);
        for jj=1:NumberOfTestPoint
            %IFpart(Rule)
            j1=1;
            for number=1:NumberOfPremiseParameters/4
                termSet{1}(number)={[swarm(gBest).Position(j1:j1+1)]};
                j1=j1+2;
            end
            for number=1:NumberOfPremiseParameters/4
                termSet{2}(number)={swarm(gBest).Position(j1:j1+1)};
                j1=j1+2;
            end
            for rule=1:length(formationMatrix)
                r1=gaussmf(testh1(jj),termSet{1}{formationMatrix(rule,1)},1);
                r2=gaussmf(testh2(jj),termSet{2}{formationMatrix(rule,2)},1);
                theata1Ofh1=gaussmf(testh1(jj),termSet{1}{formationMatrix(rule,1)},3);
                theata2Ofh1=gaussmf(testh1(jj),termSet{1}{formationMatrix(rule,1)},2);
                theata1Ofh2=gaussmf(testh2(jj),termSet{2}{formationMatrix(rule,2)},3);
                theata2Ofh2=gaussmf(testh2(jj),termSet{2}{formationMatrix(rule,2)},2);               
                BetaOfTesting(rule,jj)=r1*exp(j*(theata1Ofh1+theata2Ofh1))*r2*exp(j*(theata1Ofh2+theata2Ofh2));
            end
        end
        for K=1:NumberOfPremise
            BBOfTest(1).k(K).value=BetaOfTesting(K,:);
        end

        for N=1:1
            for K=1:NumberOfPremise
                    for Q=1:NumberOfCons
                        aocC(N).q(Q)=exp(-(C(N).q(Q)-testy(N).mean)*conj(C(N).q(Q)-testy(N).mean)/(2*testy(N).std*conj(testy(N).std)))  *exp(j*exp(-(C(N).q(Q)-testy(N).mean)*conj(C(N).q(Q)-testy(N).mean)  /(2*testy(N).std*conj(testy(N).std)))* (-(C(N).q(Q)-testy(N).mean)/(testy(N).std*conj(testy(N).std))));
                        aocS(N).q(Q)=exp(-(S(N).q(Q)*conj(S(N).q(Q)))/(2*testy(N).std*conj(testy(N).std)))*exp(j*exp(-(S(N).q(Q)*conj(S(N).q(Q)))/(2*testy(N).std))  *(-S(N).q(Q)*conj(S(N).q(Q)))/(testy(N).std*conj(testy(N).std)));
                        f1=exp(-(BBOfTest(N).k(K).value-aocC(N).q(Q)).*conj(BBOfTest(N).k(K).value-aocC(N).q(Q))./(2.*aocS(N).q(Q).*conj(aocS(N).q(Q))));
                        lambdaOfTest(N).k(K).q(Q).value=f1.*exp(j.*f1.*-(BBOfTest(N).k(K).value-aocC(N).q(Q))./(((aocS(N).q(Q)).*conj((aocS(N).q(Q))))));
                    end
            end
        end
        %new_yHead(output)
        for jj=1:NumberOfTestPoint
            for Q=1:3
                %CaculateB
                BOfTestTMP0=[];
                for N=1:1
                    TMP0=[];
                    for K=1:NumberOfPremise
                        TMP=[BBOfTest(N).k(K).value(jj)];
                        TMP0=[TMP0 TMP];
                    end
                    BOfTestTMP=[TMP0];
                    BOfTestTMP0=[BOfTestTMP0;BOfTestTMP];
                end
                BOfTest=BOfTestTMP0;
                
                %CaculateL
                LOfTestTMP0=[];
                for K=1:NumberOfPremise
                    TMP0=[];
                    for N=1:1
                        TMP=[lambdaOfTest(N).k(K).q(Q).value(jj)];
                        TMP0=[TMP0 TMP];
                    end
                    LOfTestTMP=[TMP0];
                    LOfTestTMP0=[LOfTestTMP0;LOfLambdaTMP];
                end
                LOfTest=LOfTestTMP0;
                
                %CaculateH
                HOfTestTMP0=[];
                for N=1:1
                    TMP0=[1];
                    TMP=[y(N).value(NumberOfTrainPoint+jj-1) y(N).value(NumberOfTrainPoint+jj)];
                    TMP0=[TMP0 TMP];
                    HOfTestTMP=[TMP0];
                    HOfTestTMP0=[HOfTestTMP0;HOfTestTMP];
                end
                HOfTest=HOfTestTMP0;
                
                POfTest.q(Q).value(jj,:)=BOfTest*LOfTest*HOfTest;  
            end
        end
        TMP0=[];
        for Q=1:3
            TMP=POfTest.q(Q).value;
            TMP0=[TMP0 TMP];
        end
        A=TMP0;
        output2=A*swarm(gBest).RLSE.theata;
        
%         for jj=1:NumberOfTestPoint
%             TMP1=[];
%             for k=1:length(formationMatrix)
%                 TMP=[g(k) g(k)*y(1).value(NumberOfTrainPoint+jj-1) g(k)*y(1).value(NumberOfTrainPoint+jj)];
%                 TMP1=[TMP1 TMP];
%             end
%             A(jj,:)=TMP1;
%             output2(jj,1)=A(jj,:)*swarm(gBest).RLSE.theata;  %y
%         end
        
        for jj=1:NumberOfTestPoint
            PSO.test.e(jj)=(y(1).value(jj+NumberOfTrainPoint-1)-output2(jj,1))*conj(y(1).value(jj+NumberOfTrainPoint-1)-output2(jj,1));
        end
            PSO.test.rmse=sqrt(sum(PSO.test.e)/(NumberOfTestPoint));
        plot(x,real(output2),'r--');
        plot(x,imag(output2),'r--');

toc
