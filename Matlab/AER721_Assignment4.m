%% AER721 Assigment 4
% Mahal Mammadli 500642220 
global r_es r_ms mu_sun mu_mars mu_earth
m_earth = 5.974*10^24; %kg
m_sun = 1.989*10^30; %kg
m_mars = 641.9*10^21; %kg
r_es = 149600000000; %m
r_ms = 227900000000; %m
G = 6.6742*10^-11; %m^3/kg*s^2
mu_sun=G*m_sun;
mu_mars=G*m_mars;
mu_earth=G*m_earth;
%Question 1
ra=r_ms;rp=r_es;
e=(r_ms-r_es)/(r_ms+r_es);
%Question 2
h=sqrt(2*mu_sun)*sqrt(ra*rp/(ra+rp));
%Question 3
T_ellipse=(2*pi*h^3)/(mu_sun^2*(1-e^2)^(3/2));
t=0.5*T_ellipse; %seconds
t_days=t/60/60/24;%days
%Question 4
t12=t;
T_mars=(2*pi*r_ms^(3/2))/sqrt(mu_sun);
n2=(2*pi)/T_mars;
theta_2i=pi-n2*t12;
theta_2i_deg=rad2deg(theta_2i);
%Question 5 and 6
T_earth=(2*pi*r_es^(3/2))/sqrt(mu_sun);
n1=(2*pi)/T_earth;
phi_f=pi-n1*t12;
theta_1f=pi-phi_f;
theta_1f_deg=rad2deg(theta_1f);

x1=[0 r_ms*cos(theta_2i) 0 -r_ms];
y1=[0 r_ms*sin(theta_2i) 0 0];
x2=[0 r_es 0 r_es*cos(theta_1f)];
y2=[0 0 0 r_es*sin(theta_1f)];

hold on;
grid on;
circle(0,0,r_es);
circle(0,0,r_ms);
plot(x1,y1,'-x',x2,y2,'-x');
axis([-3*10^11 3*10^11 -3*10^11 3*10^11])

%Question 7
% Initital conditions 
theta_ellipse=pi;
theta_earth=theta_1f;
t=t12;
x=0;
number_of_orbits_earth=0;
number_of_orbits_ellipse=0;

while x == 0
t=t+1000;
Me1=(2*pi*t)/T_earth;
E1 = Me1;
rr1=sqrt((1+0)/(1-0))*tan(E1/2);
theta_earth1=atan(rr1)*2;
theta_earth=round(theta_earth1,3);

Me=(2*pi*t)/T_ellipse;
E2 = kepler_E(e, Me); %[1]
rr2=sqrt((1+e)/(1-e))*tan(E2/2);
theta_ellipse1=atan(rr2)*2;
theta_ellipse=round(theta_ellipse1,3);

if theta_earth==0 && theta_ellipse==0 
    x=1;
end

if theta_earth==0
    number_of_orbits_earth=number_of_orbits_earth+1;
end
if theta_ellipse==0
    number_of_orbits_ellipse=number_of_orbits_ellipse+1;
end

end

fprintf('-----------------------------------------------------')
fprintf('\n Eccentricity of Hohmann transfer is %g', e);
fprintf('\n Angular momentum of Hohmann transfer is %g',h);
fprintf('\n Time to reach destination is %g seconds or %g days',t,t_days);
fprintf('\n Initial Mars angle is %g deg', theta_2i_deg);
fprintf('\n Final Earth angle is %g deg',theta_1f_deg);
fprintf('\n -----------------------------------------------------')
 
display(t)
display(theta_earth1)
display(theta_ellipse1)
display(number_of_orbits_earth)
display(number_of_orbits_ellipse)

function circle(x,y,r)
ang=0:0.001:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp,':');
end
%% References 
%[1] Curtis, H. D. (2013). Orbital Mechanics for Engineering Students.
% Amsterdam: Elsevier Butterworth Heinemann.
