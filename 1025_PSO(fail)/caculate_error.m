    %caculate error
    for j=1:swarm_size
        zz=linspace(-20,100,101);
        rmse=zeros(1,100);
        for ii=1:100
            t1(ii,1)=target(zz(ii));
            t2(ii,1)=fuzzyrule(j,zz(ii),zz(ii+1),swarm,1);
            rmse=sqrt(sum((t1(ii,1)-t2(ii,1)).^2/100));
        end
        %pbest
        if swarm(j,4,1)>rmse
            swarm(j,4,1)=rmse;%pbest value
            swarm(j,3,:)=swarm(j,1,:); %position
        end       
    end
    
    [~,gbest]=min(swarm(:,4,1));