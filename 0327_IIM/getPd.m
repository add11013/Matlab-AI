function output = getPd(data)

    x=data;
    pd=fitdist(x,'kernel');
    range=linspace(mean(x)-5*std(x),mean(x)+5*std(x),300);
    r=range(2)-range(1);
    y=pdf(pd,range);
    %plot(range,y);
    output=sum(y)*r;

end

