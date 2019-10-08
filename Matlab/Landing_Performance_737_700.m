%% Landing Performace for Boeing 737-700
clear
g = 9.81;
rhoSL = 1.225;
i=linspace(1,5,5);
j=linspace(1,5,5);
Wlanding = linspace(536195,569569,5);
rho(j) = [1.225,1.112,1.007,0.9093,0.8194];
for j=1:5
sigma(j) = rho(j)/rhoSL;
    for i=1:5
%Wing Parameters
b = 34.3;
S = 124.60;
e = 0.803;
AR = (b^2/S);
K = (1/(pi*AR*e));

h = 15.25;
hwing = 3.63;
tdelay = 2;
u = 0.5;

%Aerodynamic Coefficients 
Clmax = 1.85;
Clflare = 1.2;
Clapp = 1;
Cdo = 0.0177;
Cldecel = 1.45;

%Speeds
Vstall(i,j)= sqrt((2*Wlanding(i))/(rho(j)*Clmax*S));
Va(i,j)=1.3*Vstall(i,j);
Vwind = 0;%changes%
Vawind(i,j) = Va(i,j) - Vwind;
Vbar(i,j) = sqrt((Vawind(i,j)^2)/2);


theta = 0*(pi/180);
gamma = 4*(pi/180);%changes%
Geffect = 1-((1.32*(hwing/b))/(1.05+7.4*(hwing/b)));
N = 2;%or 1%
R(i,j) = Va(i,j)^2/g*((Clflare/Clapp)-1);

%Approach and flare%
tapp(i,j) = (h/(Va(i,j)*tan(gamma))) + (R(i,j)/Va(i,j))*sin(gamma/2);
Sla0(i,j) = (h/tan(gamma)) + R(i,j)*sin(gamma/2);

SLA(i,j) = Sla0(i,j) - Vwind*tapp(i,j);

%Ground roll%
Cddecel = Cdo + Geffect*K*(Cldecel^2);

Trev(i,j) = (-0.45)*N*(sigma(j)^0.8)*(89000 - 207.73*Vbar(i,j) + 0.2077*(Vbar(i,j)^2));
D(i,j) = 0.5*rho(j)*(Vbar(i,j)^2)*S*Cddecel;
L(i,j) = 0.5*rho(j)*(Vbar(i,j)^2)*S*Cldecel;

SGR1(i,j) = Vawind(i,j)*tdelay;


SGR2(i,j) = ((-Va(i,j)^2/2)/((g/Wlanding(i))*(Trev(i,j)-D(i,j)-u*(Wlanding(i)-L(i,j))-Wlanding(i)*sin(theta))));
Slanding(i,j) = SLA(i,j) + SGR1(i,j) + SGR2(i,j)
    end
mlanding=Wlanding/g;
figure(1);
plot(mlanding,Slanding,'-x');
title('Nominal Landing Performance');
ylabel('Landing Distance [m]'); 
xlabel('Landing mass [kg]');
hold on;
grid on;
end










