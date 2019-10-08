%% Takeoff Performace for Boeing 737-500
clear
g = 9.81;
i=linspace(1,5,5);
j=linspace(1,5,5);
mtakeoff(i)=linspace(46490,52390,5);
Wtakeoff(i)=mtakeoff(i)*g;
h=[0,1000,2000,3000,4000];
rho(j) = [1.225,1.112,1.007,0.9093,0.8194];
k=linspace(1,3,3);
Vwind(k)=[0,5,-5]*(1000/3600);
for k=1:3
    for j=1:5
%Density  
rhoSL = 1.225;
sigma(j) = rho(j)/rhoSL;
    for i=1:5
%Wing Parameters
b = 28.9;
S = 91.04;
e = 0.75;
AR = (b^2/S);
K = (1/(pi*AR*e));

h = 10.7; %Cleareance Height
hwing = 4;
u = 0.02;
N = 2;

%Aerodynamic coefficients
Clg = 2.05;
Clmax = 2.49;
Cdo = 0.019;

%Speeds 
Vstall(i,j) = sqrt((2*Wtakeoff(i))/(rho(j)*Clmax*S));
VLOF(i,j)=1.2*Vstall(i,j);
VgLOF(i,j) =VLOF(i,j)-Vwind(k);
V2(i,j) = 1.22*Vstall(i,j);
Vbartog(i,j) = sqrt((VLOF(i,j)^2+Vwind(k)*abs(Vwind(k)))/2);
Vbarair(i,j) = sqrt(((VLOF(i,j)^2)+(V2(i,j)^2))/2);
%Runway Angle
theta = (0*(pi/180));
%Ground Effect
Geffect = 1-((1.32*(hwing/b))/(1.05+7.4*(hwing/b)));

%Ground roll distance
Cdg = Cdo + Geffect*K*(Clg^2);
Dg(i,j) = 0.5*rho(j)*(VLOF(i,j)^2)*S*Cdg;
Lg(i,j) = 0.5*rho(j)*(VLOF(i,j)^2)*S*Clg;
Tstatic=82300;
Tg(i,j) = (sigma(j)^0.8)*N*(Tstatic - 207.73*VLOF(i,j) + 0.2077*(VLOF(i,j)^2));

Stog(i,j) = (VgLOF(i,j)^2/2)/((g/Wtakeoff(i))*(Tg(i,j)-Dg(i,j)-u*(Wtakeoff(i)-Lg(i,j))-Wtakeoff(i)*sin(theta)));
ttog(i,j)=VgLOF(i,j)/((g/Wtakeoff(i))*(Tg(i,j)-Dg(i,j)-u*(Wtakeoff(i)-Lg(i,j))-Wtakeoff(i)*sin(theta)));

%Airborne 1 Distance
Cla1(i,j) = (Wtakeoff(i)/(0.5*rho(j)*(Vbarair(i,j)^2)*S));
Cda1(i,j) = Cdo + K*(Cla1(i,j)^2);
Da(i,j)=0.5*rho(j)*(Vbarair(i,j)^2)*S*Cda1(i,j);
T1(i,j)=(sigma(j)^0.8)*N*(Tstatic - 207.73*Vbarair(i,j) + 0.2077*(Vbarair(i,j)^2));
SA1(i,j)=((((V2(i,j)^2)-(VLOF(i,j)^2)))/((2*g/Wtakeoff(i))*(T1(i,j)-Da(i,j))));
tsa1(i,j)=(V2(i,j)-VLOF(i,j))/((g/Wtakeoff(i))*(T1(i,j)-Da(i,j)));
SA1g(i,j)=SA1(i,j)-Vwind(k)*tsa1(i,j);

%Airborne 2 Distance
Cla2(i,j)=(Wtakeoff(i)/(0.5*rho(j)*(V2(i,j)^2)*S));
Cda2(i,j)=Cdo + K*(Cla2(i,j)^2);
T2(i,j)=(sigma(j)^0.8)*N*(Tstatic - 207.73*V2(i,j) + 0.2077*(V2(i,j)^2));
gamma(i,j)=asin((T2(i,j)/Wtakeoff(i))-(Cda2(i,j)/Cla2(i,j)));
SA2(i,j)=(h/tan(gamma(i,j)));
tsa2(i,j)=SA2(i,j)/(V2(i,j)*cos(gamma(i,j)));
SA2g(i,j)=SA2(i,j)-Vwind(k)*tsa2(i,j);

% Total distance%
Stakeoff(i,j) = Stog(i,j) + SA1g(i,j) + SA2g(i,j);

    end
if k==1    
figure(1);
plot(mtakeoff,Stakeoff,'-o');
title('Nominal Takeoff Performance');
ylabel('Takeoff Distance [m]'); 
xlabel('Takeoff mass [kg]');
xlim([4.6*10^4 5.5*10^4]);
hold on;
grid on;
end
figure(1);
plot(mtakeoff,Stakeoff,'--x');
title('Nominal Takeoff Performance');
ylabel('Takeoff Distance [m]'); 
xlabel('Takeoff mass [kg]');
hold on;
grid on;
    end
    
%% Balanced Field Length
if k==1
    VgEF=30;
    q=1;p=0;
while VgEF<VLOF(5,1)
%% Accelerate-Go Case
%Ground Roll Part 1
N=2;
u=0.02;
Cdg = Cdo + Geffect*K*(Clg^2);
Vavg=sqrt(VgEF^2/2);
Dg = 0.5*rho(1)*(Vavg^2)*S*Cdg;
Lg = 0.5*rho(1)*(Vavg^2)*S*Clg;
Tstatic=82300;
T = (sigma(1)^0.8)*N*(Tstatic - 207.73*Vavg + 0.2077*Vavg^2);
Stog1(q)=(VgEF^2/2)/((g/Wtakeoff(5))*(T-Dg-u*(Wtakeoff(5)-Lg)));

%Ground Roll Part 2
N=1;
Vavg=sqrt((VgEF^2+VgLOF(5,1)^2)/2);
Dg = 0.5*rho(1)*(Vavg^2)*S*Cdg;
Lg = 0.5*rho(1)*(Vavg^2)*S*Clg;
T = (sigma(1)^0.8)*N*(Tstatic - 207.73*Vavg + 0.2077*Vavg^2);
Stog2(q)=((VgLOF(5,1)^2-VgEF^2)/2)/((g/Wtakeoff(5))*(T-Dg-u*(Wtakeoff(5)-Lg)));

%Airborne 1
Cla1 = (Wtakeoff(5)/(0.5*rho(1)*(Vbarair(5,1)^2)*S));
Cda1 = Cdo + K*(Cla1^2);
Da = 0.5*rho(1)*(Vbarair(5,1)^2)*S*Cda1;
T = (sigma(1)^0.8)*N*(Tstatic - 207.73*Vbarair(5,1) + 0.2077*(Vbarair(5,1)^2));
SA1 = ((((V2(5,1)^2)-(VLOF(5,1)^2))/2)/((g/Wtakeoff(5))*(T-Da)));
tsa1=(V2(5,1)-VLOF(5,1))/((g/Wtakeoff(5))*(T-Da));
SA1gEF=SA1-Vwind(k)*tsa1;

%Airborne 2
Cla2 = (Wtakeoff(5)/(0.5*rho(1)*(V2(5,1)^2)*S));
Cda2 = Cdo + K*(Cla2^2);
T= (sigma(1)^0.8)*N*(Tstatic- 207.73*V2(5,1) + 0.2077*(V2(5,1)^2));
gamma = asin((T/Wtakeoff(5))-(Cda2/Cla2));
SA2 = (h/tan(gamma));
tsa2=SA2/(V2(5,1)*cos(gamma));
SA2gEF=SA2-Vwind(k)*tsa2;

%Total Distance
SEF1(q)=Stog1(q)+Stog2(q)+SA1gEF+SA2gEF;
SEFG(q)=Stog1(q)+Stog2(q);

%% Accelerate-Stop
%Delay
tdelay=2;
Sdelay=VgEF*tdelay;

%Ground Roll Part 2
N=1;
u=0.5;
Cldecel=0.4;
Cddecel = Cdo + Geffect*K*(Cldecel^2);
Tstatic=82300;
Vavg=sqrt(VgEF^2/2);
Trev=(-0.45)*N*(sigma(1)^0.8)*(Tstatic - 207.73*Vavg + 0.2077*Vavg^2);
Ddecel=0.5*rho(1)*(Vavg^2)*S*Cddecel;
Ldecel=0.5*rho(1)*(Vavg^2)*S*Cldecel;
Stog2EF(q)=(-VgEF^2/2)/((g/Wtakeoff(5))*(Trev-Ddecel-u*(Wtakeoff(5)-Ldecel)));

%Total Distance in accelerate-stop case
SEF2(q)=Stog1(q)+Sdelay+Stog2EF(q);

%{
Commented out due to publishing of graphs at each iteration point
figure(2);
plot(SEF1(q),VgEF,'x',SEF2(q),VgEF,'o');
title('Comparison of Accelerate-go to Accelerate-stop cases');
xlabel('Distance [km]');
ylabel('VEF [m/s]');
hold on;
grid on;
%}     
    if SEF1(q)<SEF2(q) && p<1
        display(q);
        display(VgEF);
        p=1;
        display(SEF1(q));
        display(SEF2(q));
    end

VgEF=VgEF+0.25;
q=q+1;
      
end
end
Stakeoff=(Stakeoff(:,1));
mtakeofft=mtakeoff.';
Table1=table(Stakeoff,mtakeofft)   
end

