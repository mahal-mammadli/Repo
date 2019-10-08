%% Climb Performance for Boeing 737-500 
clear
g=9.81;
%Wing Parameters
b = 28.9;
S = 91.04;
e = 0.75;
AR = (b^2/S);
K = (1/(pi*AR*e));
Clmax = 1.89;
cdo = 0.019;
%Altitude parameters
Temp = [288,281.7,275.2,268.7,262.2,255.7,249.2,242.7,236.2,229.7,223.3,216.8,216.7]; 
rho = [1.225,1.112,1.007,0.9093,0.8194,0.7364,0.6601,0.59,0.5258,0.4671,0.4135,0.3648,0.3399];%Up to 11,500 m
rhoSL=1.225;
m=52390;
W = m*g;
N = 2;
Tstatic=82300;

for i=1:13
sigma(i)=rho(i)/rhoSL;       
a(i)= sqrt(1.4*287*Temp(i));
Vstall(i) = sqrt((2*W)/(rho(i)*S*Clmax));
Vmax(i) = 0.82*a(i);
Vavg(i) = 0.5*(Vmax(i) + Vstall(i));
T(i) = N*(sigma(i)^0.85)*(Tstatic - 207.73*Vavg(i) + 0.2077*(Vavg(i)^2));
    
end

for i=1:13
V=linspace(Vstall(i),Vmax(i),10);
    for x=1:10
        Vm(x,i)=V(x);
        RC(x,i) = V(x)*((T(i)/W) - 0.5*(rho(i))*(V(x)^2)*((W/S)^(-1))*cdo - ...
        ((W/S)*(2*K)/(rho(i)*(V(x)^2))));   
end
figure(1);
plot(Vm(:,i),RC(:,i),'-');
title('Nominal Climb Performance');
xlabel('Airspeed [m/s]');
ylabel('Rate of Climb [m/s]');
hold on;
grid on;
end






