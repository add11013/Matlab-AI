LOfLambdaTMP0=[];
for K=1:NumberOfPremise
    TMP0=[];
    for N=1:1
        TMP=[lambda(N).k(K).q(Q).value(jj)];
        TMP0=[TMP0 TMP];
    end
    LOfLambdaTMP=[TMP0];
    LOfLambdaTMP0=[LOfLambdaTMP0;LOfLambdaTMP];
end
LOfLambda=LOfLambdaTMP0;