figure(3)

%% INPUT1 fuzzyset
subplot(211);
hold on
xx=linspace(0,20);
yy=gaussmf(xx,swarm(1,1:2));
plot(xx,yy);
yy=gaussmf(xx,swarm(1,3:4));
plot(xx,yy);
xlabel('X1');
ylabel('Membership Grades');


%% INPUT2 fuzzyset
subplot(212);
hold on
yy=gaussmf(xx,swarm(1,5:6));
plot(xx,yy);
yy=gaussmf(xx,swarm(1,7:8));
plot(xx,yy);
xlabel('X2');
ylabel('Membership Grades');
