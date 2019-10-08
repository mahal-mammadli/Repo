%% Assignment 2 AER721 Mahal Mammadli
%% Question 1

%Constants
G=6.67408*10^-11; 
M=5.972*10^24; %kg
Re=6371*1000; %meters
%Initital Conditions
v1=8*1000; %m/s
r1=Re+1000*1000; %meters
phi=8*(pi/180); %rad
%Parameters
C=(r1*v1^2)/(G*M);
mew=G*M;

% 1. True anomaly of orbit
theta=atan((C*cos(phi)*sin(phi))/(C*(cos(phi))^2 -1));
theta_degrees=atand((C*cos(phi)*sin(phi))/(C*(cos(phi))^2 -1));
display(theta_degrees); %degrees

% 2. Eccentricity of orbit
e=sqrt((((r1*v1^2)/(G*M))-1)^2*(cos(phi))^2+(sin(phi))^2);
format long;
display(e);

% 3. Period of orbit
a=1/(2/r1 - v1^2/(G*M));
T=2*pi*sqrt(a^3/(G*M));
display(T); %seconds

%Assign. 1 parameters
Ra=203000*1000; %m
Rp=96*1000; %m
Va=0.3449 *1000; %m/s

% 4. Eccentricity of Assign. 1 orbit
e1=(Ra-Rp)/(Ra+Rp);
display(e1);

% 5. Period of Assign.1 orbit
h1=Va*Ra;
a1=(h1^2/(G*M))*(1/(1-e1^2));
T1=2*pi*sqrt(a1^3/(G*M));
display(T1); %seconds
%% Question 2

% 6. Time until first oppurtunity for circularization manoeuver. 
theta1=theta;
theta2=pi; %180 degrees - apoapsis 
E1=2*atan((sqrt((1-e)/(1+e)))*tan(theta1/2)); %Eccentric anomaly for theta
E2=2*atan((sqrt((1-e)/(1+e)))*tan(theta2/2)); %Eccentric anomaly for 180 deg. = 180 deg.
Me1=E1-e*sin(E1); %Mean anomaly for theta
Me2=E2-e*sin(E2); %Mean anomaly for 180 deg. = 180 deg.
t1=(Me1*T)/(2*pi); %time from periapsis to theta
t2=(Me2*T)/(2*pi); %time from periapsis to apoapsis
t=t2-t1; %time from theta to apoapsis
display(t); %seconds

% 7. Radius of circle using least amount of energy. 
E_elliptical=-mew/2*a; %Energy of elliptical orbit
h=r1*v1*cos(phi);
R_p=a*(1-e); %Periapsis radius 
R_a=(h^2/mew)*(1/(1-e)); % Apoapsis radius
E_circular_p=-mew/(2*R_p); %Energy of circular orbit of Rp
E_circular_a=-mew/(2*R_a); %Energy of circular orbit of Ra
%Energy changes required for each circular orbit
delta_EP= E_circular_p - E_elliptical; 
delta_EA= E_circular_a - E_elliptical;

if (delta_EP > delta_EA)
    disp('Circle with periapsis radius requires least energy change. Radius:');
    disp(R_p); %meters
end
if (delta_EP < delta_EA)
    disp('Circle with apoapsis radius requires least energy change. Radius:');
    disp(R_a); %meters
end

% 8. Change in velocity required to achieve circular orbit at first oppurtunity. 
V_a=h/R_a;
V_circular_a=sqrt(mew/R_a);
Delta_V=V_circular_a - V_a;
display(Delta_V); %m/s

%9. Minimum time to wait until possible to manoeuver back into original ellipse. 
T_circular_a=(2*pi*R_a)/(sqrt(mew/R_a));
display(T_circular_a); %seconds

%10. Escape velocity
V_escape=sqrt(2*mew/R_a);
delta_V_escape=V_escape-V_a;
display(delta_V_escape); %m/s
%% Summary of answers
Questions=[1;2;3;4;5;6;7;8;9;10];
Answers=[theta_degrees;e;T;e1;T1;t;R_p;Delta_V;T_circular_a;delta_V_escape];
Units={'degrees';'-';'seconds';'-';'seconds';'seconds';'meters';'m/s';'seconds';'m/s'};
Table=table(Questions,Answers,Units);
display(Table);

%% References 
% ORBITAL MECHANICS. (n.d.). Retrieved October 04, 2017, from http://www.braeunig.us/space/orbmech.htm
