clear
clc

h1=[10;20;30;40;50;70;100;120;140;170;];
h1Std=std(h1);
h2=[30;40;50;60;70;80;90;100;110;120;];
h2Std=std(h2);
h=[h1;h2];
t=[];
dataset={h t};

h1Center=subclust(h1,0.5);
h2Center=subclust(h2,0.5);
for i=1:length(h1Center)
    INPUT1(i,:)=[h1Center(i) h1Std];
end

for j=1:length(h2Center)
    INPUT2(j,:)=[h2Center(j) h2Std];
end


%% fomationMatrix
k=1;
for i=1:length(h1Center)
    for j=1:length(h2Center)
        formationMatrix(k,1)=i;
        formationMatrix(k,2)=j;
        k=k+1;
    end
end
z=linspace(1,1);
x=linspace(1,200);


%% IF-Part
hold on
for i=1:length(formationMatrix)
    X1=INPUT1(formationMatrix(i,1),:);
    X2=INPUT2(formationMatrix(i,2),:);
    rule(i,:)=gaussmf(x,X1).*gaussmf(x,X2);
    %plot(x,gaussmf(x,X2));
    mesh(x,x,z);
end

