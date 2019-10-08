%Titanium 6Al-4V and Epoxy Carbon Fiber Reinforced Laminate S-N and Goodman Curves
%Titanium properties in MPa
Syt=1100;Sut=1170;
Snt=700;
%Composite properties in MPa
Syc=1590;Suc=1600;
Snc=795;
%Landing Impulse, 55 km/h stall speed 
m=575; %kg
g=9.81; %m/s^2
Vdes=55*(1000/3600)*sind(5);% m/s
t_impact=0.1;% s
Fl=m*Vdes/t_impact; %N
Fground=m*g;
Ftotal=Fground+Fl; 

w=23.98; %mm 
l=127;
Area=(w/1000)*(l/1000);

S=(Ftotal/Area)/(10^6); %MPa

%S-N Curve
x1=[10^3 10^6 10^6 10^9];
y1=[Syt*0.9 Snt Snt Snt];
y2=[Syc*0.9 Snc Snc Snc];
figure(1);
plot(x1,y1,'-x',x1,y2,'-o');
set(gca,'XScale','log');set(gca,'YScale','log');
ylim([400 1500]);
title('S-N diagram for Ti6Al4V and Epoxy Carbon Fiber');
xlabel('Number of Cycles [N]');
ylabel('S [MPa]');
legend('Ti6Al4V','Epoxy Carbon Fiber');
grid on;

%Goodman Diagram for Titanium
figure(2);
p1=[-Syt 0 Syt];
p2=[0 Syt 0];
p3=[-1500 0 Sut];
p4=[1100 1100 0];p5=[880 880 0];p6=[780 780 0];p7=[700 700 0];
plot(p1,p2,'--',p3,p4,'-',p3,p5,'-',p3,p6,'-',p3,p7,'-');
title('Goodman Diagram for Titanium 6Al-4V');
xlabel('Alternating Stress [MPa]');
ylabel('Mean Stress [MPa]');
legend('Yield Line','10^3','10^4','10^5','10^6');
grid on;
hold on;

%Goodman Diagram for Composite
figure(3);
p1=[-Syc 0 Syc];
p2=[0 Syc 0];
p3=[-2000 0 Suc];
p4=[1590 1590 0];p5=[1180 1180 0];p6=[960 960 0];p7=[795 795 0];
plot(p1,p2,'--',p3,p4,'-',p3,p5,'-',p3,p6,'-',p3,p7,'-');
title('Goodman Diagram for Epoxy Carbon Fiber Reinforced Laminate');
xlabel('Alternating Stress [MPa]');
ylabel('Mean Stress [MPa]');
legend('Yield Line','10^3','10^4','10^5','10^6');
grid on;
hold on;







