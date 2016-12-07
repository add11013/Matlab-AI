%power gauss
power_fs = [ swarm(j,1,9) swarm(j,1,10);
             swarm(j,1,11) swarm(j,1,12);
             swarm(j,1,13) swarm(j,1,14);
             swarm(j,1,15) swarm(j,1,16)];
for k = 1:4
    power_mf(k,:) = gaussmf(z, power_fs(k,:));
end