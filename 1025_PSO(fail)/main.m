clear;
clc;close all;
%% initialization

swarm_size = 40;                       % number of the swarm particles
maxIter = 200;                         % maximum number of iterations
inertia = 0.85;                        % W
correction_factor = 2.0;               % c1,c2
initial_swarm;

%% target
target=@(x) (x-30).^2+100;

%% main loop
 point_n=100;
 x = linspace(-20,15, point_n);
 y = linspace( 1,100, point_n);
 z = linspace(100,800, point_n);
 for j=1:swarm_size
        temperatureIni;
        quantityIni;
        powerIni;
end
for i=1:maxIter
    %move
    swarm(:,1,:) = swarm(:,1,:) + swarm(:,2,:);
    caculate_error;
    changeVelocity;
end
 plotResult;