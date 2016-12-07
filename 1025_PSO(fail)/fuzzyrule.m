%StartOrNow(SON)    5:start   1:Now
function output=fuzzyrule(j,x,y,swarm,SON)
        mf1x = gaussmf(x, swarm(j,SON,1:2));
		mf2x = gaussmf(x, swarm(j,SON,3:4));
		mf1y = gaussmf(y, swarm(j,SON,5:6));
		mf2y = gaussmf(y, swarm(j,SON,7:8));
		w1 = min(mf1x, mf1y);%freeze&less
		w2 = min(mf1x, mf2y);%freeze&more
		w3 = min(mf2x, mf1y);%cold&less
		w4 = min(mf2x, mf2y);%cold&more
        z = linspace(100,800);
		qualified_power_mf(1, :) = min(w1,gaussmf(z, swarm(j,SON,9:10)));
		qualified_power_mf(2, :) = min(w2,gaussmf(z, swarm(j,SON,11:12)));
		qualified_power_mf(3, :) = min(w3,gaussmf(z, swarm(j,SON,13:14)));
		qualified_power_mf(4, :) = min(w4,gaussmf(z, swarm(j,SON,15:16)));
		overall_out_mf = max(qualified_power_mf);
		output = defuzzy(z, overall_out_mf, 1);
end