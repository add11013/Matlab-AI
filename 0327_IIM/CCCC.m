function output = CCCC(data,f1,f2)
    %ConditionEntropy: H(f1->f2)
    %NorP:1 is Positive,2 is Negative
    
    x=data(:,f1);
    y=data(:,f2);
    r_y=linspace(mean(y)-5*std(y),mean(y)+5*std(y),300);
    ry=r_y(2)-r_y(1);
    r_x=linspace(mean(x)-5*std(x),mean(x)+5*std(x),300);
    rx=r_x(2)-r_x(1);
    output=sum(getPdf(x).*rx.*sum(getPdf(y).*log(getPdf(y)./getPdf(y)))).*ry;
end

