%% Advanced Composite Wing Box design
clear
clc
SF=1.5;
%% First Iteration 
%Positioning at origin
x1=[0 0 2760 2760 0]; %2.76 meters in width 2760 mm
y1=[0 660 495 165 0];
plot(x1,y1,'-+r');
grid on;
ylim([-100 800]);xlim([-100 3000]);
refline(0,330);
ybar=330;

%Distance between booms b=2760 mm
tw=5; %Web panel thickness
ts=5; %Skin panel thickness
b1y=330;b2y=165;b3y=-330;b4y=-165;%y distance from n/a
by=[b1y;b2y;b3y;b4y];
Ac=300;%Connection between vertical web and skin

%Corner Boom Areas
B1=((ts*2760)/6)*(2+b2y/b1y)+((tw*660)/6)*(2+b3y/b1y)+Ac;
B2=((ts*2760)/6)*(2+b1y/b2y)+((tw*330)/6)*(2+b4y/b2y)+Ac;
B3=B1;
B4=B2;
B=[B1;B2;B3;B4];

%x centroid  distance
xbar=(2*B2*2760)/(2*B1+2*B2);
line([xbar,xbar],[-100,3000]);
b1x=xbar;b2x=2760-xbar;
b3x=b1x;b4x=b2x;
bx=[b1x;b2x;b3x;b4x];

%Moment of inertias
Ixx1=B1*b1y^2;Iyy1=B1*b1x^2;
Ixx2=B2*b2y^2;Iyy2=B2*b2x^2;
Ixx3=B3*b3y^2;Iyy3=B3*b3x^2;
Ixx4=B4*b4y^2;Iyy4=B4*b4x^2;
Ixxt=[Ixx1;Ixx2;Ixx3;Ixx4];
Iyyt=[Iyy1;Iyy2;Iyy3;Iyy4];
Ixx=Ixx1+Ixx2+Ixx3+Ixx4;
Iyy=Iyy1+Iyy2+Iyy3+Iyy4;

%PHAA Stresses
Mx=1773682; %Nm
Mx=1773682*(1000); %Nmm
Sigmaz1=(Mx/Ixx)*b1y*SF;
Sigmaz2=(Mx/Ixx)*b2y*SF;
Sigmaz3=(Mx/Ixx)*b3y*SF;
Sigmaz4=(Mx/Ixx)*b4y*SF;

PHAA_sigmaz=[Sigmaz1;Sigmaz2;Sigmaz3;Sigmaz4];

%PLAA Stresses
Mx=1760536.082; %Nm
Mx=Mx*(1000); %Nmm
My=107409.5956;
My=My*1000;%Nmm
Sigmaz11=((Mx/Ixx)*b1y+(My/Iyy)*b1x)*SF;
Sigmaz22=((Mx/Ixx)*b2y+(My/Iyy)*b2x)*SF;
Sigmaz33=((Mx/Ixx)*b3y+(My/Iyy)*b3x)*SF;
Sigmaz44=((Mx/Ixx)*b4y+(My/Iyy)*b4x)*SF;

PLAA_sigmaz=[Sigmaz11;Sigmaz22;Sigmaz33;Sigmaz44];

%Plate Buckling 
Kc=7; % Loaded Edges Clamped 
b=2760;a=2500;% distance between panels mm
E=117000;% MPa
v=0.5;% Estimate 
sigma_cr=Kc*pi^2*E/(12*(1-v^2))*(ts/b)^2;
display(sigma_cr);

%Shear flows
Sy1=232686.5796;%PHAA
Sy2=224251.5756; %PLAA
Sx1=10883.26785; %PLAA
% PHAA
%Cutting through boom 1-2
q12=0;
q24=-Sy1/Ixx*(B2*b2y);
q43=0; %Symmetry
q13=-Sy1/Ixx*(B1*b1y);

qs0=(q24*(330)*2760)/(2760*495);
q12=qs0;q24=q24+qs0;
q43=-qs0;q13=q13+qs0;

shear_flowsPHAA=[q12;;q24;q43;q13];
shear_stressesPHAA=[q12/ts;q24/tw;q43/ts;q13/tw]*SF;

% PLAA
q12y=0;q12x=0;
q24y=-Sy2/Ixx*(B2*b2y);q24x=-Sx1/Iyy*(B2*b2x);
q43y=0;q43x=0; %Symmetry
q13y=-Sy2/Ixx*(B1*b1y);q13x=-Sx1/Iyy*(B1*b1x);

qs0y=(q24y*(330)*2760)/(2760*495);
q12y=qs0y;q24y=q24y+qs0y+q24x;
q43y=-qs0y;q13y=q13y+qs0y+q13x;

shear_flowsPLAA=[q12y;q24y;q43y;q13y];
shear_stressesPLAA=[q12y/ts;q24y/tw;q43y/ts;q13y/tw]*SF;


table(B,by,bx,Ixxt,Iyyt,PHAA_sigmaz,PLAA_sigmaz)
table(B,shear_flowsPHAA,shear_stressesPHAA,shear_flowsPLAA,shear_stressesPLAA)

%% Second Iteration Root Stresses- 4 stringers added
x1=[0 0 920 1840 2760 2760 1840 920 0]; %2.76 meters in width 2760 mm
y1=[0 660 550+55 440+110 495 165 110 55 0];
figure(2);
plot(x1,y1,'-+r');
grid on;
ylim([-100 800]);xlim([-100 3000]);
refline(0,330);


tw=8; %Web panel thickness
ts=10.5; %Skin panel thickness
b1y=330;b2y=275;b3y=220;b4y=165;%y distance from n/a
b5y=-165;b6y=-220;b7y=-275;b8y=-330;
by=[b1y;b2y;b3y;b4y;b5y;b6y;b7y;b8y];
Ac=300;%Connection between vertical web and skin

%Boom Areas
B1=((ts*920)/6)*(2+b2y/b1y)+((tw*660)/6)*(2+b8y/b1y)+Ac;
B2=((ts*920)/6)*(2+b1y/b2y)+((ts*920)/6)*(2+b3y/b2y)+Ac;
B3=((ts*920)/6)*(2+b2y/b3y)+((ts*920)/6)*(2+b4y/b3y)+Ac;
B4=((tw*330)/6)*(2+b5y/b4y)+((ts*920)/6)*(2+b3y/b4y)+Ac;
B8=B1;B6=B3;
B7=B2;B5=B4;
B=[B1;B2;B3;B4;B5;B6;B7;B8];

%x centroid  distance
xbar=(2*B2*920+2*B3*1840+2*B4*2760)/(2*B1+2*B2+2*B3+2*B4);
line([xbar,xbar],[-100,3000]);
b1x=xbar;b4x=2760-xbar;b2x=xbar-920;b3x=xbar-1840;
b8x=b1x;b5x=b4x;b6x=b3x;b7x=b2x;
bx=[b1x;b2x;b3x;b4x;b5x;b6x;b7x;b8x];

%Moment of inertias
Ixx1=B1*b1y^2;Iyy1=B1*b1x^2;
Ixx2=B2*b2y^2;Iyy2=B2*b2x^2;
Ixx3=B3*b3y^2;Iyy3=B3*b3x^2;
Ixx4=B4*b4y^2;Iyy4=B4*b4x^2;
Ixx5=B5*b5y^2;Iyy5=B5*b5x^2;
Ixx6=B6*b6y^2;Iyy6=B6*b6x^2;
Ixx7=B7*b7y^2;Iyy7=B7*b7x^2;
Ixx8=B8*b8y^2;Iyy8=B8*b8x^2;
Ixx=Ixx1+Ixx2+Ixx3+Ixx4+Ixx5+Ixx6+Ixx7+Ixx8;
Iyy=Iyy1+Iyy2+Iyy3+Iyy4+Iyy5+Iyy6+Iyy7+Iyy8;
Ixxt=[Ixx1;Ixx2;Ixx3;Ixx4;Ixx5;Ixx6;Ixx7;Ixx8];
Iyyt=[Iyy1;Iyy2;Iyy3;Iyy4;Iyy5;Iyy6;Iyy7;Iyy8];

%PHAA Stresses
Mx=1773682; %Nm
Mx=1773682*(1000); %Nmm
Sigmaz1=(Mx/Ixx)*b1y*SF;
Sigmaz2=(Mx/Ixx)*b2y*SF;
Sigmaz3=(Mx/Ixx)*b3y*SF;
Sigmaz4=(Mx/Ixx)*b4y*SF;
Sigmaz5=(Mx/Ixx)*b5y*SF;
Sigmaz6=(Mx/Ixx)*b6y*SF;
Sigmaz7=(Mx/Ixx)*b7y*SF;
Sigmaz8=(Mx/Ixx)*b8y*SF;

PHAA_sigmaz=[Sigmaz1;Sigmaz2;Sigmaz3;Sigmaz4;Sigmaz5;Sigmaz6;Sigmaz7;...
    Sigmaz8];

%PLAA Stresses
Mx=1760536.082; %Nm
Mx=Mx*(1000); %Nmm
My=107409.5956;
My=My*1000;%Nmm
Sigmaz11=((Mx/Ixx)*b1y+(My/Iyy)*b1x)*SF;
Sigmaz22=((Mx/Ixx)*b2y+(My/Iyy)*b2x)*SF;
Sigmaz33=((Mx/Ixx)*b3y+(My/Iyy)*b3x)*SF;
Sigmaz44=((Mx/Ixx)*b4y+(My/Iyy)*b4x)*SF;
Sigmaz55=((Mx/Ixx)*b5y+(My/Iyy)*b5x)*SF;
Sigmaz66=((Mx/Ixx)*b6y+(My/Iyy)*b6x)*SF;
Sigmaz77=((Mx/Ixx)*b7y+(My/Iyy)*b7x)*SF;
Sigmaz88=((Mx/Ixx)*b8y+(My/Iyy)*b8x)*SF;

PLAA_sigmaz=[Sigmaz11;Sigmaz22;Sigmaz33;Sigmaz44;Sigmaz55;Sigmaz66;...
    Sigmaz77;Sigmaz88];

%Plate Buckling 
Kc=7; % Loaded Edges Clamped 
b=920;a=2500;% mm
E=117000;% MPa
v=0.5;% Estimate 
sigma_cr2=Kc*pi^2*E/(12*(1-v^2))*(ts/b)^2;
display(sigma_cr2);

%Shear flows
Sy1=232686.5796;%PHAA
Sy2=224251.5756; %PLAA
Sx1=10883.26785; %PLAA

%PHAA 
%Cutting through 1-2
q12=0;
q23=-Sy1/Ixx*(B2*b2y);
q34=-Sy1/Ixx*(B3*b3y)+q23;
q45=-Sy1/Ixx*(B4*b4y)+q34;
q18=-Sy1/Ixx*(B1*b1y);

qs0=(q45*330*2760)/(496*2760);
q12=q12+qs0;q23=q23+qs0;q34=q34+qs0;q45=q45+qs0;
q56=-q34;q67=-q23;q78=-q12;q18=q18+qs0;
shear_flowsPHAA=[q12;q23;q34;q45;q56;q67;q78;q18];
shear_stressesPHAA=[q12/ts;q23/ts;q34/ts;q45/tw;q56/ts;q67/ts;q78/ts;...
    q18/tw]*SF;

%PLAA
q12y=0;q12x=0;
q23y=-Sy2/Ixx*(B2*b2y);q23x=-Sx1/Iyy*(B2*b2x);
q34y=-Sy2/Ixx*(B3*b3y)+q23;q34x=-Sx1/Iyy*(B3*b3x); %Symmetry
q45y=-Sy2/Ixx*(B4*b4y)+q34;q45x=-Sx1/Iyy*(B4*b4x);
q18y=-Sy2/Ixx*(B1*b1y);q18x=-Sx1/Iyy*(B1*b1y);

qs0y=(q23y*(b2y)*920+q34*b3y*2*(920))/(2760*495);
q12y=qs0y;q23y=q23y+qs0y+q23x;
q34y=q34y+qs0y;q18y=q18y+qs0y+q18x;
q56y=-q34y;q67y=-q23y;q78y=q12y;

shear_flowsPLAA=[q12y;q23y;q34y;q45y;q56y;q67y;q78y;q18y];
shear_stressesPLAA=[q12y/ts;q23y/ts;q34y/ts;q45y/tw;q56y/ts;q67y/ts;...
    q78y/ts;q18y/tw]*SF;


table(B,by,bx,Ixxt,Iyyt,PHAA_sigmaz,PLAA_sigmaz)
table(B,shear_flowsPHAA,shear_stressesPHAA,shear_flowsPLAA,shear_stressesPLAA)

%% Station 2 - 2 meters down the wing
%Length reduces from 2760 to 2484
x2=[0 0 828 1656 2484 2484 1656 828 0]; %2.76 meters in width 2760 mm
y2=[0 596.2 596.2-48.2 596.2-96.4 451.6 144.6 96.4 48.2 0];
plot(x1,y1,'-+r',x2,y2,'-+r');
ylim([-100 800]);xlim([-100 3000]);
refline(0,596.2/2);
hold on;

tw=8; %Web panel thickness
ts=10.5; %Skin panel thickness
b1y=298.1;b2y=249.9;b3y=201.7;b4y=153.5;%y distance from n/a
b5y=-153.5;b6y=-201.7;b7y=-249;b8y=-298.1;
by=[b1y;b2y;b3y;b4y;b5y;b6y;b7y;b8y];
Ac=300;%Connection between vertical web and skin

%Boom Areas
B1=((ts*828)/6)*(2+b2y/b1y)+((tw*596.2)/6)*(2+b8y/b1y)+Ac;
B2=((ts*828)/6)*(2+b1y/b2y)+((ts*828)/6)*(2+b3y/b2y)+Ac;
B3=((ts*828)/6)*(2+b2y/b3y)+((ts*828)/6)*(2+b4y/b3y)+Ac;
B4=((tw*307)/6)*(2+b5y/b4y)+((ts*828)/6)*(2+b3y/b4y)+Ac;
B8=B1;B6=B3;
B7=B2;B5=B4;
B=[B1;B2;B3;B4;B5;B6;B7;B8];

%x centroid  distance
xbar=(2*B2*828+2*B3*1656+2*B4*2484)/(2*B1+2*B2+2*B3+2*B4);
line([xbar,xbar],[-100,3000]);
b1x=xbar;b4x=2760-xbar;b2x=xbar-920;b3x=xbar-1840;
b8x=b1x;b5x=b4x;b6x=b3x;b7x=b2x;
bx=[b1x;b2x;b3x;b4x;b5x;b6x;b7x;b8x];

%Moment of inertias
Ixx1=B1*b1y^2;Iyy1=B1*b1x^2;
Ixx2=B2*b2y^2;Iyy2=B2*b2x^2;
Ixx3=B3*b3y^2;Iyy3=B3*b3x^2;
Ixx4=B4*b4y^2;Iyy4=B4*b4x^2;
Ixx5=B5*b5y^2;Iyy5=B5*b5x^2;
Ixx6=B6*b6y^2;Iyy6=B6*b6x^2;
Ixx7=B7*b7y^2;Iyy7=B7*b7x^2;
Ixx8=B8*b8y^2;Iyy8=B8*b8x^2;
Ixx=Ixx1+Ixx2+Ixx3+Ixx4+Ixx5+Ixx6+Ixx7+Ixx8;
Iyy=Iyy1+Iyy2+Iyy3+Iyy4+Iyy5+Iyy6+Iyy7+Iyy8;
Ixxt=[Ixx1;Ixx2;Ixx3;Ixx4;Ixx5;Ixx6;Ixx7;Ixx8];
Iyyt=[Iyy1;Iyy2;Iyy3;Iyy4;Iyy5;Iyy6;Iyy7;Iyy8];

%PHAA Stresses at 2 meters
Mx=1376548.576; %Nm
Mx=1376548.576*(1000); %Nmm
Sigmaz1=(Mx/Ixx)*b1y*SF;
Sigmaz2=(Mx/Ixx)*b2y*SF;
Sigmaz3=(Mx/Ixx)*b3y*SF;
Sigmaz4=(Mx/Ixx)*b4y*SF;
Sigmaz5=(Mx/Ixx)*b5y*SF;
Sigmaz6=(Mx/Ixx)*b6y*SF;
Sigmaz7=(Mx/Ixx)*b7y*SF;
Sigmaz8=(Mx/Ixx)*b8y*SF;

PHAA_sigmaz=[Sigmaz1;Sigmaz2;Sigmaz3;Sigmaz4;Sigmaz5;Sigmaz6;Sigmaz7;...
    Sigmaz8];

%PLAA Stresses
Mx=1324298.909; %Nm
Mx=Mx*(1000); %Nmm
My=88689.30912;
My=My*1000;%Nmm
Sigmaz11=((Mx/Ixx)*b1y+(My/Iyy)*b1x)*SF;
Sigmaz22=((Mx/Ixx)*b2y+(My/Iyy)*b2x)*SF;
Sigmaz33=((Mx/Ixx)*b3y+(My/Iyy)*b3x)*SF;
Sigmaz44=((Mx/Ixx)*b4y+(My/Iyy)*b4x)*SF;
Sigmaz55=((Mx/Ixx)*b5y+(My/Iyy)*b5x)*SF;
Sigmaz66=((Mx/Ixx)*b6y+(My/Iyy)*b6x)*SF;
Sigmaz77=((Mx/Ixx)*b7y+(My/Iyy)*b7x)*SF;
Sigmaz88=((Mx/Ixx)*b8y+(My/Iyy)*b8x)*SF;

PLAA_sigmaz=[Sigmaz11;Sigmaz22;Sigmaz33;Sigmaz44;Sigmaz55;Sigmaz66;...
    Sigmaz77;Sigmaz88];

%Plate Buckling 
Kc=7; % Loaded Edges Clamped 
b=828;
E=117000;% MPa
v=0.5;% Estimate 
sigma_cr2=Kc*pi^2*E/(12*(1-v^2))*(ts/b)^2;
display(sigma_cr2);

%Shear flows 
Sy1=165044.3431;%PHAA
Sy2=157596.4306; %PLAA
Sx1=7823.854681; %PLAA

%PHAA 
%Cutting through 1-2
q12=0;
q23=-Sy1/Ixx*(B2*b2y);
q34=-Sy1/Ixx*(B3*b3y)+q23;
q45=-Sy1/Ixx*(B4*b4y)+q34;
q18=-Sy1/Ixx*(B1*b1y);

qs0=(q45*330*2760)/(496*2760);
q12=q12+qs0;q23=q23+qs0;q34=q34+qs0;q45=q45+qs0;
q56=-q34;q67=-q23;q78=-q12;q18=q18+qs0;
shear_flowsPHAA=[q12;q23;q34;q45;q56;q67;q78;q18];
shear_stressesPHAA=[q12/ts;q23/ts;q34/ts;q45/tw;q56/ts;q67/ts;q78/ts;...
    q18/tw]*SF;

%PLAA
q12y=0;q12x=0;
q23y=-Sy2/Ixx*(B2*b2y);q23x=-Sx1/Iyy*(B2*b2x);
q34y=-Sy2/Ixx*(B3*b3y)+q23;q34x=-Sx1/Iyy*(B3*b3x); %Symmetry
q45y=-Sy2/Ixx*(B4*b4y)+q34;q45x=-Sx1/Iyy*(B4*b4x);
q18y=-Sy2/Ixx*(B1*b1y);q18x=-Sx1/Iyy*(B1*b1y);

qs0y=(q23y*(b2y)*920+q34*b3y*2*(920))/(2760*495);
q12y=qs0y;q23y=q23y+qs0y+q23x;
q34y=q34y+qs0y;q18y=q18y+qs0y+q18x;
q56y=-q34y;q67y=-q23y;q78y=q12y;

shear_flowsPLAA=[q12y;q23y;q34y;q45y;q56y;q67y;q78y;q18y];
shear_stressesPLAA=[q12y/ts;q23y/ts;q34y/ts;q45y/tw;q56y/ts;q67y/ts;...
    q78y/ts;q18y/tw]*SF;


table(B,by,bx,Ixxt,Iyyt,PHAA_sigmaz,PLAA_sigmaz)
table(B,shear_flowsPHAA,shear_stressesPHAA,shear_flowsPLAA,shear_stressesPLAA)

%% Station 3 - 8 meters down the wing
%Length reduces from 2484 to 1656
x3=[0 0 552 1104 1656 1656 1104 552 0]; %2.76 meters in width 2760 mm
y3=[0 397.44 397.44-32.13 397.44-2*32.13 301.06 96.38 64.25 32.13 0];
plot(x1,y1,'-+r',x2,y2,'-+r',x3,y3,'-+r');
ylim([-100 800]);xlim([-100 3000]);
refline(0,397.44/2);
hold on;

tw=8; %Web panel thickness
ts=10.5; %Skin panel thickness
b1y=198.72;b2y=166.59;b3y=134.46;b4y=102.33;%y distance from n/a
b5y=-102.33;b6y=-134.46;b7y=-166.59;b8y=-198.72;
by=[b1y;b2y;b3y;b4y;b5y;b6y;b7y;b8y];
Ac=300;%Connection between vertical web and skin

%Boom Areas
B1=((ts*552)/6)*(2+b2y/b1y)+((tw*397.44)/6)*(2+b8y/b1y)+Ac;
B2=((ts*552)/6)*(2+b1y/b2y)+((ts*552)/6)*(2+b3y/b2y)+Ac;
B3=((ts*552)/6)*(2+b2y/b3y)+((ts*552)/6)*(2+b4y/b3y)+Ac;
B4=((tw*204.68)/6)*(2+b5y/b4y)+((ts*552)/6)*(2+b3y/b4y)+Ac;
B8=B1;B6=B3;
B7=B2;B5=B4;
B=[B1;B2;B3;B4;B5;B6;B7;B8];

%x centroid  distance
xbar=(2*B2*828+2*B3*1656+2*B4*2484)/(2*B1+2*B2+2*B3+2*B4);
line([xbar,xbar],[-100,3000]);
b1x=xbar;b4x=2760-xbar;b2x=xbar-920;b3x=xbar-1840;
b8x=b1x;b5x=b4x;b6x=b3x;b7x=b2x;
bx=[b1x;b2x;b3x;b4x;b5x;b6x;b7x;b8x];

%Moment of inertias
Ixx1=B1*b1y^2;Iyy1=B1*b1x^2;
Ixx2=B2*b2y^2;Iyy2=B2*b2x^2;
Ixx3=B3*b3y^2;Iyy3=B3*b3x^2;
Ixx4=B4*b4y^2;Iyy4=B4*b4x^2;
Ixx5=B5*b5y^2;Iyy5=B5*b5x^2;
Ixx6=B6*b6y^2;Iyy6=B6*b6x^2;
Ixx7=B7*b7y^2;Iyy7=B7*b7x^2;
Ixx8=B8*b8y^2;Iyy8=B8*b8x^2;
Ixx=Ixx1+Ixx2+Ixx3+Ixx4+Ixx5+Ixx6+Ixx7+Ixx8;
Iyy=Iyy1+Iyy2+Iyy3+Iyy4+Iyy5+Iyy6+Iyy7+Iyy8;
Ixxt=[Ixx1;Ixx2;Ixx3;Ixx4;Ixx5;Ixx6;Ixx7;Ixx8];
Iyyt=[Iyy1;Iyy2;Iyy3;Iyy4;Iyy5;Iyy6;Iyy7;Iyy8];

%PHAA Stresses at 8 meters
Mx=393694.0684; %Nm
Mx=393694.0684*(1000); %Nmm
Sigmaz1=(Mx/Ixx)*b1y*SF;
Sigmaz2=(Mx/Ixx)*b2y*SF;
Sigmaz3=(Mx/Ixx)*b3y*SF;
Sigmaz4=(Mx/Ixx)*b4y*SF;
Sigmaz5=(Mx/Ixx)*b5y*SF;
Sigmaz6=(Mx/Ixx)*b6y*SF;
Sigmaz7=(Mx/Ixx)*b7y*SF;
Sigmaz8=(Mx/Ixx)*b8y*SF;

PHAA_sigmaz=[Sigmaz1;Sigmaz2;Sigmaz3;Sigmaz4;Sigmaz5;Sigmaz6;Sigmaz7;...
    Sigmaz8];

%PLAA Stresses
Mx=384774.9375; %Nm
Mx=Mx*(1000); %Nmm
My=31288.55012;
My=My*1000;%Nmm
Sigmaz11=((Mx/Ixx)*b1y+(My/Iyy)*b1x)*SF;
Sigmaz22=((Mx/Ixx)*b2y+(My/Iyy)*b2x)*SF;
Sigmaz33=((Mx/Ixx)*b3y+(My/Iyy)*b3x)*SF;
Sigmaz44=((Mx/Ixx)*b4y+(My/Iyy)*b4x)*SF;
Sigmaz55=((Mx/Ixx)*b5y+(My/Iyy)*b5x)*SF;
Sigmaz66=((Mx/Ixx)*b6y+(My/Iyy)*b6x)*SF;
Sigmaz77=((Mx/Ixx)*b7y+(My/Iyy)*b7x)*SF;
Sigmaz88=((Mx/Ixx)*b8y+(My/Iyy)*b8x)*SF;

PLAA_sigmaz=[Sigmaz11;Sigmaz22;Sigmaz33;Sigmaz44;Sigmaz55;Sigmaz66;...
    Sigmaz77;Sigmaz88];

%Plate Buckling 
Kc=7; % Loaded Edges Clamped 
b=552;% mm
E=117000;% MPa
v=0.5;% Estimate 
sigma_cr2=Kc*pi^2*E/(12*(1-v^2))*(ts/b)^2;
display(sigma_cr2);

%Shear flows 
Sy1=88250.77128;%PHAA
Sy2=84673.4174; %PLAA
Sx1=6583.401235; %PLAA

%PHAA 
%Cutting through 1-2
q12=0;
q23=-Sy1/Ixx*(B2*b2y);
q34=-Sy1/Ixx*(B3*b3y)+q23;
q45=-Sy1/Ixx*(B4*b4y)+q34;
q18=-Sy1/Ixx*(B1*b1y);

qs0=(q45*330*2760)/(496*2760);
q12=q12+qs0;q23=q23+qs0;q34=q34+qs0;q45=q45+qs0;
q56=-q34;q67=-q23;q78=-q12;q18=q18+qs0;
shear_flowsPHAA=[q12;q23;q34;q45;q56;q67;q78;q18];
shear_stressesPHAA=[q12/ts;q23/ts;q34/ts;q45/tw;q56/ts;q67/ts;q78/ts;...
    q18/tw]*SF;

%PLAA
q12y=0;q12x=0;
q23y=-Sy2/Ixx*(B2*b2y);q23x=-Sx1/Iyy*(B2*b2x);
q34y=-Sy2/Ixx*(B3*b3y)+q23;q34x=-Sx1/Iyy*(B3*b3x); %Symmetry
q45y=-Sy2/Ixx*(B4*b4y)+q34;q45x=-Sx1/Iyy*(B4*b4x);
q18y=-Sy2/Ixx*(B1*b1y);q18x=-Sx1/Iyy*(B1*b1y);

qs0y=(q23y*(b2y)*920+q34*b3y*2*(920))/(2760*495);
q12y=qs0y;q23y=q23y+qs0y+q23x;
q34y=q34y+qs0y;q18y=q18y+qs0y+q18x;
q56y=-q34y;q67y=-q23y;q78y=q12y;

shear_flowsPLAA=[q12y;q23y;q34y;q45y;q56y;q67y;q78y;q18y];
shear_stressesPLAA=[q12y/ts;q23y/ts;q34y/ts;q45y/tw;q56y/ts;q67y/ts;...
    q78y/ts;q18y/tw]*SF;


table(B,by,bx,Ixxt,Iyyt,PHAA_sigmaz,PLAA_sigmaz)
table(B,shear_flowsPHAA,shear_stressesPHAA,shear_flowsPLAA,shear_stressesPLAA)

%% Station 4 - 15 meters down the wing
%Length reduces from 1656 to 690
x4=[0 0 230 460 690 690 460 230 0]; %2.76 meters in width 2760 mm
y4=[0 165.6 165.6-13.386 165.6-2*13.386 125.442 40.158 26.772 13.386 0];
plot(x1,y1,'-+r',x2,y2,'-+r',x3,y3,'-+r',x4,y4,'-+r');
ylim([-100 800]);xlim([-100 3000]);
refline(0,165.6/2);
hold on;

tw=8; %Web panel thickness
ts=10.5; %Skin panel thickness
b1y=82.8;b2y=69.414;b3y=56.028;b4y=42.642;%y distance from n/a
b5y=-42.642;b6y=-56.028;b7y=-69.414;b8y=-82.8;
by=[b1y;b2y;b3y;b4y;b5y;b6y;b7y;b8y];
Ac=300;%Connection between vertical web and skin

%Boom Areas
B1=((ts*230)/6)*(2+b2y/b1y)+((tw*165.6)/6)*(2+b8y/b1y)+Ac;
B2=((ts*230)/6)*(2+b1y/b2y)+((ts*230)/6)*(2+b3y/b2y)+Ac;
B3=((ts*230)/6)*(2+b2y/b3y)+((ts*230)/6)*(2+b4y/b3y)+Ac;
B4=((tw*85.285)/6)*(2+b5y/b4y)+((ts*230)/6)*(2+b3y/b4y)+Ac;
B8=B1;B6=B3;
B7=B2;B5=B4;
B=[B1;B2;B3;B4;B5;B6;B7;B8];

%x centroid  distance
xbar=(2*B2*828+2*B3*1656+2*B4*2484)/(2*B1+2*B2+2*B3+2*B4);
line([xbar,xbar],[-100,3000]);
b1x=xbar;b4x=2760-xbar;b2x=xbar-920;b3x=xbar-1840;
b8x=b1x;b5x=b4x;b6x=b3x;b7x=b2x;
bx=[b1x;b2x;b3x;b4x;b5x;b6x;b7x;b8x];

%Moment of inertias
Ixx1=B1*b1y^2;Iyy1=B1*b1x^2;
Ixx2=B2*b2y^2;Iyy2=B2*b2x^2;
Ixx3=B3*b3y^2;Iyy3=B3*b3x^2;
Ixx4=B4*b4y^2;Iyy4=B4*b4x^2;
Ixx5=B5*b5y^2;Iyy5=B5*b5x^2;
Ixx6=B6*b6y^2;Iyy6=B6*b6x^2;
Ixx7=B7*b7y^2;Iyy7=B7*b7x^2;
Ixx8=B8*b8y^2;Iyy8=B8*b8x^2;
Ixx=Ixx1+Ixx2+Ixx3+Ixx4+Ixx5+Ixx6+Ixx7+Ixx8;
Iyy=Iyy1+Iyy2+Iyy3+Iyy4+Iyy5+Iyy6+Iyy7+Iyy8;
Ixxt=[Ixx1;Ixx2;Ixx3;Ixx4;Ixx5;Ixx6;Ixx7;Ixx8];
Iyyt=[Iyy1;Iyy2;Iyy3;Iyy4;Iyy5;Iyy6;Iyy7;Iyy8];

%PHAA Stresses at 8 meters
Mx=4806.706072; %Nm
Mx=Mx*(1000); %Nmm
Sigmaz1=(Mx/Ixx)*b1y*SF;
Sigmaz2=(Mx/Ixx)*b2y*SF;
Sigmaz3=(Mx/Ixx)*b3y*SF;
Sigmaz4=(Mx/Ixx)*b4y*SF;
Sigmaz5=(Mx/Ixx)*b5y*SF;
Sigmaz6=(Mx/Ixx)*b6y*SF;
Sigmaz7=(Mx/Ixx)*b7y*SF;
Sigmaz8=(Mx/Ixx)*b8y*SF;

PHAA_sigmaz=[Sigmaz1;Sigmaz2;Sigmaz3;Sigmaz4;Sigmaz5;Sigmaz6;Sigmaz7;...
    Sigmaz8];

%PLAA Stresses
Mx=4787.479248; %Nm
Mx=Mx*(1000); %Nmm
My=215.114524;
My=My*1000;%Nmm
Sigmaz11=((Mx/Ixx)*b1y+(My/Iyy)*b1x)*SF;
Sigmaz22=((Mx/Ixx)*b2y+(My/Iyy)*b2x)*SF;
Sigmaz33=((Mx/Ixx)*b3y+(My/Iyy)*b3x)*SF;
Sigmaz44=((Mx/Ixx)*b4y+(My/Iyy)*b4x)*SF;
Sigmaz55=((Mx/Ixx)*b5y+(My/Iyy)*b5x)*SF;
Sigmaz66=((Mx/Ixx)*b6y+(My/Iyy)*b6x)*SF;
Sigmaz77=((Mx/Ixx)*b7y+(My/Iyy)*b7x)*SF;
Sigmaz88=((Mx/Ixx)*b8y+(My/Iyy)*b8x)*SF;

PLAA_sigmaz=[Sigmaz11;Sigmaz22;Sigmaz33;Sigmaz44;Sigmaz55;Sigmaz66;...
    Sigmaz77;Sigmaz88];

%Plate Buckling 
Kc=7; % Loaded Edges Clamped 
b=230;% mm
E=117000;% MPa
v=0.5;% Estimate 
sigma_cr2=Kc*pi^2*E/(12*(1-v^2))*(ts/b)^2;
display(sigma_cr2);

%Shear flows 
Sy1=9613.412144;%PHAA
Sy2=9574.958496; %PLAA
Sx1=430.2290479; %PLAA

%PHAA 
%Cutting through 1-2
q12=0;
q23=-Sy1/Ixx*(B2*b2y);
q34=-Sy1/Ixx*(B3*b3y)+q23;
q45=-Sy1/Ixx*(B4*b4y)+q34;
q18=-Sy1/Ixx*(B1*b1y);

qs0=(q45*330*2760)/(496*2760);
q12=q12+qs0;q23=q23+qs0;q34=q34+qs0;q45=q45+qs0;
q56=-q34;q67=-q23;q78=-q12;q18=q18+qs0;
shear_flowsPHAA=[q12;q23;q34;q45;q56;q67;q78;q18];
shear_stressesPHAA=[q12/ts;q23/ts;q34/ts;q45/tw;q56/ts;q67/ts;q78/ts;...
    q18/tw]*SF;

%PLAA
q12y=0;q12x=0;
q23y=-Sy2/Ixx*(B2*b2y);q23x=-Sx1/Iyy*(B2*b2x);
q34y=-Sy2/Ixx*(B3*b3y)+q23;q34x=-Sx1/Iyy*(B3*b3x); %Symmetry
q45y=-Sy2/Ixx*(B4*b4y)+q34;q45x=-Sx1/Iyy*(B4*b4x);
q18y=-Sy2/Ixx*(B1*b1y);q18x=-Sx1/Iyy*(B1*b1y);

qs0y=(q23y*(b2y)*920+q34*b3y*2*(920))/(2760*495);
q12y=qs0y;q23y=q23y+qs0y+q23x;
q34y=q34y+qs0y;q18y=q18y+qs0y+q18x;
q56y=-q34y;q67y=-q23y;q78y=q12y;

shear_flowsPLAA=[q12y;q23y;q34y;q45y;q56y;q67y;q78y;q18y];
shear_stressesPLAA=[q12y/ts;q23y/ts;q34y/ts;q45y/tw;q56y/ts;q67y/ts;...
    q78y/ts;q18y/tw]*SF;


table(B,by,bx,Ixxt,Iyyt,PHAA_sigmaz,PLAA_sigmaz)
table(B,shear_flowsPHAA,shear_stressesPHAA,shear_flowsPLAA,shear_stressesPLAA)

