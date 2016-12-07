%set INPUT1 parameter(Quantity)
A1=[20,20];A2=[40,20];
A3=[60,20];A4=[80,20];
Quantity={A1,A2,A3,A4};
INPUT(1)={Quantity};

%set INPUT2 parameter(Temperature)
B1=[-20,20];B2=[-10,20];
B3=[0,20];
Temperature={B1,B2,B3};
INPUT(2)={Temperature};

formationMatrix=[
    1 1;
    1 2;
    1 3;
    2 1;
    2 2;
    2 3;
    3 1;
    3 2;
    3 3;
    4 1;
    4 2;
    4 3;];