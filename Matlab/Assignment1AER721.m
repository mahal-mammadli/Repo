% wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
function Example_11_03
% wwwwwwwwwwwwwwwwwwwwww
%{
This program numerically integrates Equations 11.6 through
11.8 for a gravity turn trajectory.
User M-functions required: rkf45
User subfunction required: rates
%}
% ----------------------------------------------
clear all;close all;clc
deg ¼ pi/180; % ...Convert degrees to radians
g0 ¼ 9.81; % ...Sea-level acceleration of gravity (m/s)
Re ¼ 6378e3; % ...Radius of the earth (m)
hscale ¼ 7.5e3; % ...Density scale height (m)
rho0 ¼ 1.225; % ...Sea level density of atmosphere (kg/m^3)
diam ¼ 196.85/12 ...
*0.3048; % ...Vehicle diameter (m)
A ¼ pi/4*(diam)^2; % ...Frontal area (m^2)
CD ¼ 0.5; % ...Drag coefficient (assumed constant)
m0 ¼ 149912*.4536; % ...Lift-off mass (kg)
n ¼ 15; % ...Mass ratio
T2W ¼ 1.4; % ...Thrust to weight ratio
Isp ¼ 390; % ...Specific impulse (s)
mfinal ¼ m0/n; % ...Burnout mass (kg)
Thrust ¼ T2W*m0*g0; % ...Rocket thrust (N)
m_dot ¼ Thrust/Isp/g0; % ...Propellant mass flow rate (kg/s)
mprop ¼ m0 - mfinal; % ...Propellant mass (kg)
e132 MATLAB Scripts
tburn ¼ mprop/m_dot; % ...Burn time (s)
hturn ¼ 130; % ...Height at which pitchover begins (m)
t0 ¼ 0; % ...Initial time for the numerical integration
tf ¼ tburn; % ...Final time for the numerical integration
tspan ¼ [t0,tf]; % ...Range of integration
% ...Initial conditions:
v0 ¼ 0; % ...Initial velocity (m/s)
gamma0 ¼ 89.85*deg; % ...Initial flight path angle (rad)
x0 ¼ 0; % ...Initial downrange distance (km)
h0 ¼ 0; % ...Initial altitude (km)
vD0 ¼ 0; % ...Initial value of velocity loss due
% to drag (m/s)
vG0 ¼ 0; % ...Initial value of velocity loss due
% to gravity (m/s)
%...Initial conditions vector:
f0 ¼ [v0; gamma0; x0; h0; vD0; vG0];
%...Call to Runge-Kutta numerical integrator ‘rkf45’
% rkf45 solves the system of equations df/dt ¼ f(t):
[t,f] ¼ rkf45(@rates, tspan, f0);
%...t is the vector of times at which the solution is evaluated
%...f is the solution vector f(t)
%...rates is the embedded function containing the df/dt’s
% ...Solution f(t) returned on the time interval [t0 tf]:
v ¼ f(:,1)*1.e-3; % ...Velocity (km/s)
gamma ¼ f(:,2)/deg; % ...Flight path angle (degrees)
x ¼ f(:,3)*1.e-3; % ...Downrange distance (km)
h ¼ f(:,4)*1.e-3; % ...Altitude (km)
vD ¼ -f(:,5)*1.e-3; % ...Velocity loss due to drag (km/s)
vG ¼ -f(:,6)*1.e-3; % ...Velocity loss due to gravity (km/s)
for i ¼ 1:length(t)
Rho ¼ rho0 * exp(-h(i)*1000/hscale); %...Air density
q(i) ¼ 1/2*Rho*v(i)^2; %...Dynamic pressure
end
output
return
%wwwwwwwwwwwwwwwwwwwwwwwww
function dydt ¼ rates(t,y)
%wwwwwwwwwwwwwwwwwwwwwwwww
MATLAB Scripts e133
% Calculates the time rates df/dt of the variables f(t)
% in the equations of motion of a gravity turn trajectory.
%-------------------------
%...Initialize dfdt as a column vector:
dfdt ¼ zeros(6,1);
v ¼ y(1); % ...Velocity
gamma ¼ y(2); % ...Flight path angle
x ¼ y(3); % ...Downrange distance
h ¼ y(4); % ...Altitude
vD ¼ y(5); % ...Velocity loss due to drag
vG ¼ y(6); % ...Velocity loss due to gravity
%...When time t exceeds the burn time, set the thrust
% and the mass flow rate equal to zero:
if t < tburn
m ¼ m0 - m_dot*t; % ...Current vehicle mass
T ¼ Thrust; % ...Current thrust
else
m ¼ m0 - m_dot*tburn; % ...Current vehicle mass
T ¼ 0; % ...Current thrust
end
g ¼ g0/(1 + h/Re)^2; % ...Gravitational variation
% with altitude h
rho ¼ rho0 * exp(-h/hscale); % ...Exponential density variation
% with altitude
D ¼ 1/2 * rho*v^2 * A * CD; % ...Drag [Equation 11.1]
%...Define the first derivatives of v, gamma, x, h, vD and vG
% ("dot" means time derivative):
%v_dot ¼ T/m - D/m - g*sin(gamma); % ...Equation 11.6
%...Start the gravity turn when h ¼ hturn:
if h <¼ hturn
gamma_dot ¼ 0;
v_dot ¼ T/m - D/m - g;
x_dot ¼ 0;
h_dot ¼ v;
vG_dot ¼ -g;
else
v_dot ¼ T/m - D/m - g*sin(gamma);
gamma_dot ¼ -1/v*(g - v^2/(Re + h))*cos(gamma);% ...Equation 11.7
x_dot ¼ Re/(Re + h)*v*cos(gamma); % ...Equation 11.8(1)
h_dot ¼ v*sin(gamma); % ...Equation 11.8(2)
vG_dot ¼ -g*sin(gamma); % ...Gravity loss rate
end
e134 MATLAB Scripts
vD_dot ¼ -D/m; % ...Drag loss rate
%...Load the first derivatives of f(t) into the vector dfdt:
dydt(1) ¼ v_dot;
dydt(2) ¼ gamma_dot;
dydt(3) ¼ x_dot;
dydt(4) ¼ h_dot;
dydt(5) ¼ vD_dot;
dydt(6) ¼ vG_dot;
end
%wwwwwwwwwwwwww
function output
%wwwwwwwwwwwwww
fprintf(‘\n\n -----------------------------------\n’)
fprintf(‘\n Initial flight path angle ¼ %10g deg ‘,gamma0/deg)
fprintf(‘\n Pitchover altitude ¼ %10g m ‘,hturn)
fprintf(‘\n Burn time ¼ %10g s ‘,tburn)
fprintf(‘\n Final speed ¼ %10g km/s’,v(end))
fprintf(‘\n Final flight path angle ¼ %10g deg ‘,gamma(end))
fprintf(‘\n Altitude ¼ %10g km ‘,h(end))
fprintf(‘\n Downrange distance ¼ %10g km ‘,x(end))
fprintf(‘\n Drag loss ¼ %10g km/s’,vD(end))
fprintf(‘\n Gravity loss ¼ %10g km/s’,vG(end))
fprintf(‘\n\n -----------------------------------\n’)
figure(1)
plot(x, h)
axis equal
xlabel(‘Downrange Distance (km)’)
ylabel(‘Altitude (km)’)
axis([-inf, inf, 0, inf])
grid
figure(2)
subplot(2,1,1)
plot(h, v)
xlabel(‘Altitude (km)’)
ylabel(‘Speed (km/s)’)
axis([-inf, inf, -inf, inf])
grid
subplot(2,1,2)
plot(t, gamma)
xlabel(‘Time (s)’)
ylabel(‘Flight path angle (deg)’)
axis([-inf, inf, -inf, inf])
grid
MATLAB Scripts e135
figure(3)
plot(h, q)
xlabel(‘Altitude (km)’)
ylabel(‘Dynamic pressure (N/m^2)’)
axis([-inf, inf, -inf, inf])
grid
end %output
end %Example_11_03
