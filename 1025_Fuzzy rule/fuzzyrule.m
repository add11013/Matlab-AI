function output=fuzzyrule(i,j,point_n)
        temperatureIni;
        quantityIni;
        powerIni;
		mf1x = gaussmf(i, temp_fs(1, :));
		mf2x = gaussmf(i, temp_fs(2, :));
		mf1y = gaussmf(j, quantity_fs(1, :));
		mf2y = gaussmf(j, quantity_fs(2, :));
		w1 = min(mf1x, mf1y);%freeze&less
		w2 = min(mf1x, mf2y);%freeze&more
		w3 = min(mf2x, mf1y);%cold&less
		w4 = min(mf2x, mf2y);%cold&more
		qualified_power_mf(1, :) = min(w1, power_mf(1, :));
		qualified_power_mf(2, :) = min(w2, power_mf(2, :));
		qualified_power_mf(3, :) = min(w3, power_mf(3, :));
		qualified_power_mf(4, :) = min(w4, power_mf(4, :));
		overall_out_mf = max(qualified_power_mf);
		output = defuzzy(z, overall_out_mf, 1);
end