        zz=linspace(-20,100,101);
        for ii=1:100
            t1(ii,1)=target(zz(ii));
            t2(ii,1)=fuzzyrule(gbest,zz(ii),zz(ii+1),swarm,5);
            t3(ii,1)=fuzzyrule(gbest,zz(ii),zz(ii+1),swarm,1);
        end
        zz=linspace(-20,100,100);
        subplot(211)
        plot(zz,t1,zz,t2);
        axis([-inf inf 100 800])
        subplot(212)
        plot(zz,t1,zz,t3);
        axis([-inf inf 100 800])