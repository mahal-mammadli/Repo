%% Range-Payload Diagram at 10,000 meters for Boeing 737-500
clear
rhoSL = 1.225;
rho = 0.4135;
sigma = rho/rhoSL;
a = 299.5; % Speed of sound at 10,000 m %
%Wing Parameters
b = 28.9;
S = 91.04;
e = 0.75;
AR = (b^2/S);
K = (1/(pi*AR*e));
cdo = 0.019;

Rcd = 500; 
M = 0.82;
V = M*a; % m/s %
Vr = V*(3600/1000); % Km/h %
g = 9.81;

%Engine and Fuel Values
N = 2;
Tstatic=82300;
T = (sigma^0.85)*N*(Tstatic - 207.73*V + 0.2077*(V^2));
Fuelburn = 2100;
TSFC = Fuelburn/T;

%Weights
mtotal=52390;
mmaxpayload=15530;
mmaxfuel=mmaxpayload+554;
mzerofuel=46490;
mempty=30960;
mclimb=1250;
mdec=775;

Wtotal = mtotal*g;
Wmaxpayload = mmaxpayload*g;
Wmaxfuel = mmaxfuel*g;
Wzerofuel = mzerofuel*g;
Wempty = mempty*g;
Wclimb = mclimb*g;
Wdec = mdec*g;

%PART 1 Max P/L , MTOW 
Wfo1 = Wtotal - Wempty - Wmaxpayload;
Wint1 = Wtotal - Wclimb;
Wfnl1 = Wint1 - (Wfo1 - Wclimb - Wdec);
Wbar1 = sqrt(Wint1*Wfnl1);
Cl1 = ((2*Wbar1)/(rho*(V^2)*S));
Cd1 = cdo + K*Cl1;

%Range 1 
r1 = (Vr/g)*((Cl1/Cd1)/(TSFC))*(log(Wint1/Wfnl1));
R1 = Rcd + r1;

%PART 2 MAX Fuel , MTOW 
Wfo2 = Wmaxfuel;
WPL2 = Wtotal - Wempty - Wfo2;
Wint2 = Wint1;
Wfnl2 = Wempty + WPL2 + Wdec;
Wbar2 = sqrt(Wint2*Wfnl2);
Cl2 = ((2*Wbar2)/(rho*(V^2)*S));
Cd2 = cdo + K*Cl2;

%Range 2
r2 = (Vr/g)*((Cl2/Cd2)/(TSFC))*(log(Wint2/Wfnl2));
R2 = Rcd + r2;

%PART 3 -- NO PAYLOAD/MAX FUEL
Wfo3 = Wmaxfuel;
WPL3 = 0;
Wint3 = Wempty + Wfo3 - Wclimb;
Wfnl3 = Wempty + WPL3 + Wdec;
Wbar3 = sqrt(Wint3*Wfnl3);
Cl3 = ((2*Wbar3)/(rho*(V^2)*S));
Cd3 = cdo + K*Cl3;

%Range 3 
r3 = (Vr/g)*((Cl3/Cd3)/(TSFC))*(log(Wint3/Wfnl3));
R3 = Rcd + r3;

%PART 4 Optimum TP 
Wfo4 = Wmaxfuel;
Wint4 = Wtotal;
Wfnl4 = Wempty;
WPL4 = 0;
Wbar4 = sqrt(Wint4*Wfnl4);
Cl4 = ((2*Wbar4)/(rho*(V^2)*S));
Cd4 = cdo + K*Cl4;

%Range 4 
r4 = (Vr/g)*((Cl4/Cd4)/(TSFC))*(log(Wint4/Wfnl4));
R4 = Rcd + r4;

%Plot 

rangex = [0 R1 R2 R3];
rangey = [mmaxpayload mmaxpayload WPL2/g WPL3/g];
otpx = [R2 R4];
otpy = [WPL2/g WPL4/g];
plot (rangex,rangey,'-x',otpx,otpy,'--o')
title('Range-Payload Diagram for Boeing 737-500')
xlabel('Range [km]')
ylabel('Payload Mass [kg]')
legend('Range-Payload','Optimal Transport Productivity');
hold on;
grid on;

