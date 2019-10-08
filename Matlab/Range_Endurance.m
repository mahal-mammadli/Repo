%% Range and Endurance Analysis for Boeing 737-500 
clear
g = 9.81;

rhoSL = 1.225;
rho = 1.007; %at 2,000 m 
sigma = rho/rhoSL;

N = 2;
Vcr = 253.33; %cruise speed m/s
Tstatic=82300;
T = (sigma^0.80)*N*(Tstatic - 207.73*Vcr + 0.2077*(Vcr^2)); 
fuelburn = 2100;
TSFC =fuelburn/T;

%Wing Parameters
b = 28.9;
S = 91.04;
e = 0.75;
AR = (b^2/S);
K = (1/(pi*AR*e));
cdo=0.019;

m1=52390;
m2=46490;
W1 = m1*g;
W2 = m2*g;
Wbar = sqrt(W1*W2);

Clme = sqrt(cdo/K);
Cdme = 2*cdo;
Vme = sqrt((2*Wbar)/(rho*S*Clme));
Vmr = (1.32*Vme);
Clmr = (Wbar/(0.5*rho*(Vmr^2)*S));

Cdmr = cdo + K*(Clmr^2);
Vr = (Vcr*3.6); %km/h

%Max Range
Vmr = (1.32*Vme);
MaxRange = (1/g)*(Vr/TSFC)*(Clmr/Cdmr)*log(W1/W2) %km 

%Maximum Endurance 
timeme = (MaxRange/Vr) %hours 
