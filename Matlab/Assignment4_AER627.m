%% Question 1
L=20;R=[5 5 5];
y=pi/4;
alpha=[pi/2 7*pi/6 -pi/6];
beta=0;

w_1=[sin(alpha(1)+beta+y);-cos(alpha(1)+beta+y);-L*cos(beta+y)];
w_2=[sin(alpha(2)+beta+y);-cos(alpha(2)+beta+y);-L*cos(beta+y)];
w_3=[sin(alpha(3)+beta+y);-cos(alpha(3)+beta+y);-L*cos(beta+y)];

u_1=[cos(alpha(1)+beta+y);sin(alpha(1)+beta+y);L*sin(beta+y)];
u_2=[cos(alpha(2)+beta+y);sin(alpha(2)+beta+y);L*sin(beta+y)];
u_3=[cos(alpha(3)+beta+y);sin(alpha(3)+beta+y);L*sin(beta+y)];

J2=diag(R);

J1=[w_1.';w_2.';w_3.'];
J1_inv=inv(J1);
%Horizontal segment of 2 m
for i=0:0.005:1
v=[i;0;0];R=0.05;
phi=J1*v;
phi1=phi(1,1)/R*cos(y);phi2=phi(2,1)/R*cos(y);phi3=phi(3,1)/R*cos(y);
%Max speed allowed is 2 rad/s
if abs(phi1) <2 && abs(phi2)<2 && abs(phi3)<2
    i=i;
end
end
% approximate max i value for max wheel speeds is 0.145 m/s
v=[0.145;0;0];
phix=J1*[0.145;0;0];
phi1x=phix(1,1)/R*cos(y);phi2x=phix(2,1)/R*cos(y);phi3x=phix(3,1)/R*cos(y);

tx=2*2/(0.145);

%Vertical segment of 0.75 m
for i=0:0.005:1
v=[0;i;0];R=0.05;
phi=J1*v;
phi1=phi(1,1)/R*cos(y);phi2=phi(2,1)/R*cos(y);phi3=phi(3,1)/R*cos(y);
%Max speed allowed is 2 rad/s
if abs(phi1) <2 && abs(phi2)<2 && abs(phi3)<2
    i=i;
end
end
% approximate max i value for max wheel speeds is 0.145 m/s
v=[0;0.145;0];
phiy=J1*[0;0.145;0];
phi1y=phiy(1,1)/R*cos(y);phi2y=phiy(2,1)/R*cos(y);phi3y=phiy(3,1)/R*cos(y);

ty=2*0.75/(0.145);
ttotal=tx+ty

t1=linspace(0,tx/2,100);
t2=linspace(tx/2,tx/2+ty/2,100);
phi1x=linspace(phi1x,phi1x,100);
phi2x=linspace(phi2x,phi2x,100);
phi3x=linspace(phi3x,phi3x,100);
phi1y=linspace(phi1y,phi1y,100);
phi2y=linspace(phi2y,phi2y,100);
phi3y=linspace(phi3y,phi3y,100);

plot(t1,phi1x,t1,phi2x,t1,phi3x,t2,phi1y,'--',t2,phi2y,'--',t2,phi3y,'--');
title('Wheel speeds vs. time for 2 m [x] and 0.75 m [y] drive only');
legend('phi1 x direction','phi2 x direction','phi3 x direction',...
    'phi1 y direction','phi2 y direction','phi3 y direction');
xlim([0 30]);
grid on;



