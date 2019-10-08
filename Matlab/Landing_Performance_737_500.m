%% Landing Performace for Boeing 737-500
clear
g = 9.81;
rhoSL = 1.225;
i=linspace(1,5,5);
j=linspace(1,5,5);
mlanding=linspace(46490,49900,5);
Wlanding=mlanding*g;
rho(j) = [1.225,1.112,1.007,0.9093,0.8194];
Vwind=[0,5,-5]*(1000/3600);
for k=1:3
    for j=1:5
    sigma(j) = rho(j)/rhoSL;
        for i=1:5
%Wing Parameters
b = 28.9;
S = 91.04;
e = 0.75;
AR = (b^2/S);
K = (1/(pi*AR*e));

h = 15.25;
hwing = 4;
tdelay = 3;
u = 0.5;

%Aerodynamic Coefficients 
Clmax = 2.5;
Clflare = 2.1;
Clapp = 2.02;
Cdo = 0.019;
Cldecel = 0.6;

%Speeds
Vstall(i,j)= sqrt((2*Wlanding(i))/(rho(j)*Clmax*S));
Va(i,j)=1.2*Vstall(i,j);
Vag(i,j) = Va(i,j)-Vwind(k);
Vbar(i,j) = sqrt((Vag(i,j)^2+Vwind(k)*abs(Vwind(k)))/2);


theta = 0*(pi/180);
gamma = 3*(pi/180);
Geffect = 1-((1.32*(hwing/b))/(1.05+7.4*(hwing/b)));
N = 2;
R(i,j) = Va(i,j)^2/(g*((Clflare/Clapp)-1));

%Approach and flare
tapp(i,j) = (h/(Va(i,j)*tan(gamma))) + (R(i,j)/Va(i,j))*sin(gamma/2);
Sla0(i,j) = (h/tan(gamma)) + R(i,j)*sin(gamma/2);

SLA(i,j) = Sla0(i,j)-Vwind(k)*tapp(i,j);

%Ground roll
Cddecel = Cdo + Geffect*K*(Cldecel^2);
Tstatic=82300;
Trev(i,j) = (-0.45)*N*(sigma(j)^0.8)*(Tstatic - 207.73*Vbar(i,j) + 0.2077*(Vbar(i,j)^2));
D(i,j) = 0.5*rho(j)*(Vbar(i,j)^2)*S*Cddecel;
L(i,j) = 0.5*rho(j)*(Vbar(i,j)^2)*S*Cldecel;

SGR1(i,j) = Vag(i,j)*tdelay;
SGR2(i,j) = ((-Va(i,j)^2/2)/((g/Wlanding(i))*(Trev(i,j)-D(i,j)-u*(Wlanding(i)-L(i,j))-Wlanding(i)*sin(theta))));
Slanding(i,j) = SLA(i,j) + SGR1(i,j) + SGR2(i,j);
        end
if k==1
    mlanding=Wlanding/g;
    figure(1);  
    plot(mlanding,Slanding,'-o');
    title('Nominal Landing Performance');
    ylabel('Landing Distance [m]'); 
    xlabel('Landing mass [kg]');
    xlim([4.6*10^4 5.1*10^4]);
    hold on;
    grid on;
end
mlanding=Wlanding/g;
figure(1);
plot(mlanding,Slanding,'--x');
title('Nominal Landing Performance');
ylabel('Landing Distance [m]'); 
xlabel('Landing mass [kg]');
xlim([4.6*10^4 5.1*10^4]);
hold on;
grid on;
    end
Slanding=(Slanding(:,1));
mlandingt=mlanding.';
Table1=table(Slanding,mlandingt)   
end










