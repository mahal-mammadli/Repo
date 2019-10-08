%% Flight Envelope for Boeing 737-500
clear
g=9.81;
m=52390;
W = m*g;
h=[0,1000,2000,3000,4000,5000,6000,7000,8000,9000,10000,11000,11500];
rho = [1.225,1.112,1.007,0.9093,0.8194,0.7364,0.6601,0.59,0.5258,0.4671,0.4135,0.3648,0.3399];%Up to 11,500 m
temp = [228,281.7,275.2,268.7,262.2,255.7,249.2,242.7,236.2,229.7,223.3,216.8,216.7];%Up to 11,500 m
S = 91.04;
Clmax = 2.2;
Cl = 0.43;
a = sqrt(1.4*287*temp);
Qmax=10767.98;

for x=1:13
Vstall(x) = sqrt((2*W)/(rho(x)*Clmax*S));
Vmax(x) = 0.82*a(x);
Vqmax(x)=sqrt((2*Qmax)/rho(x));
end

x1=[Vmax(13),Vstall(13)];
y1=[h(13),h(13)];
plot(Vmax,h,'-xb',Vstall,h,'-xb',x1,y1,'b',Vqmax,h,'--');
axis([0 400 0 13000]);
title('Flight Envelope')
xlabel('Airspeed (m/s)')
ylabel('Altitude (m)') 
hold on;
grid on;