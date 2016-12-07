%quantity gauss
 quantity_fs = [ swarm(j,1,5),swarm(j,1,6);
                 swarm(j,1,7),swarm(j,1,8)];
for k = 1:2,
   quantity_mf(k,:) = gaussmf(y, quantity_fs(k,:));
end