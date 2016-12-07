%term_set{1} is Quantity fuzzy set 
%term_set{2} is Temperaturefuzzy set
%and formationMatrix decides the fuzzy set A1 A2...,B1 B2...
function output=IFpart(formationMatrix,INPUT)
    x=linspace(1,100);
    for i=1:length(formationMatrix)
        X1=INPUT{1}{formationMatrix(i,1)};
        X2=INPUT{2}{formationMatrix(i,2)};
        rule(i,:)=gaussmf(x,X1).*gaussmf(x,X2);
    end
    output=rule;
end
