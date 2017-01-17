figure(4)

%% INPUT1 fuzzyset
subplot(211);
hold on
xx=linspace(0,20);
yy=gaussmf(xx,swarm(gbest,1:2));
plot(xx,yy);
yy=gaussmf(xx,swarm(gbest,3:4));
plot(xx,yy);
xlabel('X1');
ylabel('Membership Grades');


%% INPUT2 fuzzyset
subplot(212);
hold on
yy=gaussmf(xx,swarm(gbest,5:6));
plot(xx,yy);
yy=gaussmf(xx,swarm(gbest,7:8));
plot(xx,yy);
xlabel('X2');
ylabel('Membership Grades');
