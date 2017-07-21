HOfLambdaTMP0=[];
for N=1:1
    TMP0=[1];
    TMP=[y(N).value(jj) y(N).value(jj+1)];
    TMP0=[TMP0 TMP];
    HOfLambdaTMP=[TMP0];
    HOfLambdaTMP0=[HOfLambdaTMP0;HOfLambdaTMP];
end
HOfLambda=HOfLambdaTMP0;