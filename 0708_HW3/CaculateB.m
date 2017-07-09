BOfLambdaTMP0=[];
for N=1:1
    TMP0=[];
    for K=1:NumberOfPremise
        TMP=[B(N).k(K).value(jj)];
        TMP0=[TMP0 TMP];
    end
    BOfLambdaTMP=[TMP0];
    BOfLambdaTMP0=[BOfLambdaTMP0;BOfLambdaTMP];
end
BOfLambda=BOfLambdaTMP0;