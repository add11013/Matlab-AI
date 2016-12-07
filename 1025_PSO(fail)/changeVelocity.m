    %change velocity
    for j=1:swarm_size
        A=inertia*swarm(j,2,:);%ºD©Ê
        B=correction_factor*rand(1)*0.1*(swarm(j,3,:)-swarm(j,1,:));%pbest
        C=correction_factor*rand(1)*0.1*(swarm(gbest,3,:) - swarm(j,1,:));%gbest
        swarm(j,2,:)=A+B+C;
    end