clear
clc
tic
Xopt=5;
D=1000000;
initial.Position=randn;
accuracy=1e-8;
maxIte=2000*D;
gbest=1;
gbestDistance=1e8;
gbestPosition=0;
for ite=1:maxIte
    stepsize=max((maxIte-ite-1500*D)/maxIte,accuracy/D);
    for i=1:3
        swarm(i).Position=gbestPosition+randn*stepsize*sqrt(D);
        y(i)=fcost(swarm(i).Position,Xopt);
        swarm(i).ite(ite).error=y(i)-Xopt;
        if swarm(i).ite(ite).error<gbestDistance
            gbestDistance=swarm(i).ite(ite).error;
            gbestPosition=swarm(i).Position;
        end
        if swarm(i).ite(ite).error<accuracy
            toc
            return;
        end
    end
