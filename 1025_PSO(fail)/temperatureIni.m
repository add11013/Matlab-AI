temp_fs = [ swarm(j,1,1),swarm(j,1,2);
            swarm(j,1,3),swarm(j,1,4)];
        for k = 1:2,
            temp_mf(k,:) = gaussmf(x, temp_fs(k,:));
        end