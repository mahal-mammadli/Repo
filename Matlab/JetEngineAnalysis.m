%% Jet Engine Analysis 

%% Initial parameters

V_user = 50; % m/s
%for V_user = 0:5:50


% Diffusor
n_d = 0.9;
y_d = 1.4;

% Compressor
n_c = 0.95;
y_c = 1.37;

ratio_c = 11;
%for ratio_c = 6:1:15


%Inlet and Outlet 
r_i=0.14; %inlet radius m
r_e=0.115; %outlet radius m
%for r_i = 0.15:0.01:0.25
%for r_e = 0.05:0.01:0.15

% Burner
n_b = 0.99;
y_b = 1.35;
ratio_b = 0.95;

T_max = 1000; % Kelvin
T_max_C = T_max-273;
Q_R = 42e6;

% Turbine
n_t = 0.92;
n_m = 0.99;
y_t = 1.33;

% Nozzle 
n_n = 0.9;
y_n = 1.4;

% Flight Conditions -> 500 m (1640 ft)
Temp = 273.13 + 15; % Kelvin
y_air = 1.4;
R_air = 287;
P_inf = 95.4; % Kpa
rho_inf = 1.1254; % kg/m^3



a = sqrt(y_air*R_air*Temp);
Mach = V_user/a;

%% Intake (Diffuser)

y_d_t = (y_d)/(y_d-1);

T_02 = Temp*(1+((y_d-1)/2)*(Mach^2));
P_02 = (P_inf)*((1+n_d*(T_02/Temp-1))^(y_d_t));

%% Compressor

y_c_t = (y_c-1)/(y_c);

T_03 = T_02*(1+(1/n_c)*((ratio_c^y_c_t)-1));
P_03 = ratio_c*P_02;

Cp_c = (y_c*R_air)/(y_c-1); % J/Kg.K

%% Combustor (Burner)

Cp_b_bar = (y_b*R_air)/(y_b-1); % J/Kg.K
Cp_b_exit = 2*Cp_b_bar - Cp_c;

T_04 = T_max;
P_04 = ratio_b*P_03; % Burner Exit

f = ((T_04/T_03)-(Cp_c/Cp_b_exit))/(((n_b*Q_R)/(Cp_b_exit*T_03))-(T_04/T_04));

%% Turbine

y_t_t = (y_t)/(y_t-1);

T_05 = T_04-(1/n_m)*(T_03-T_02);
P_05 = P_04*(1 - (1/n_t)*(1-(T_05/T_04)))^(y_t_t);

%% No Afterburner

T_06 = T_05;
P_06 = P_05;

%% Choking Criterion 

a1 = ((y_n+1)/2)^(y_n/(y_n-1)); 
a2 = P_06/P_inf; 

if a1 > a2
    disp('Warning! Flow is not choked');
end 

% Therefore, Since a2>a1 -> Flow is Choked 
y_n_t = (y_n)/(y_n-1);
Cp_n = ((y_n*R_air)/(y_n-1)); % J/Kg.K

V_e = sqrt(2*Cp_n*T_06*((y_n-1)/(y_n+1))); % Exit Velocity m/s
P_7 = P_06*(2/(y_n+1))^y_n_t;
P_e = P_7;
Ae_m = (((y_n+1)/2)^(1/(y_n-1)))*(((y_n+1)/(2*y_n*R_air*T_06))^0.5)*(((R_air*T_06)/(P_06*1000)));

F_ma = (1+f)*V_e - V_user + Ae_m*(P_e - P_inf)*(1+f);

TSFC_s = (f/F_ma); %kg/s.N
TSFC_hr = (f/F_ma)*3600; % kg/h.N

%% Overall,Thermal and Propulsive Efficiency

y_n_t2 = (y_n-1)/(y_n);
V_e_free = sqrt(2*n_n*Cp_n*T_06*((1-(P_inf/P_06))^(y_n_t2))); % m/s 

n_th = (((1+f)*(V_e)^2/2)-((V_user^2)/2))/(f*Q_R);
n_o = (1/TSFC_s)*(V_user/Q_R);
n_p = (F_ma*V_user)/(((1+f)*((V_e)^2)/2)-(((V_user^2)/2)));



%% Thrust Generated 

A_i = (pi*r_i^2)/4; % Meters -> Inlet Area
A_e = (pi*r_e^2)/4; % Meters -> Outlet Area
M_flow_i = rho_inf*A_i*V_user; % Kg/s
rho_e = P_e*1000/(R_air*T_06); % kg/m^3
M_flow_e = rho_e*A_e*V_e; % Kg/s
F_gen = (M_flow_e*V_e) - (M_flow_i*V_user) + (P_e - P_inf)*A_e; % N 




%% Range 

range = 30; %km
t_hr = range/V_user*3.6; %hrs
t_s = range*1000/V_user;
mdot_f_hr = TSFC_hr*F_gen; %kg/hr
mdot_f_s = TSFC_s*F_gen; %kg/s

m_fuel = mdot_f_s*t_s;


%% Take off Estimation 
g = 9.81;
n = 2; %number of engines

%Weight of the device

m_device = pi*(0.08*2726*0.05*r_i^2 + 0.50*2726*0.1*r_i^2 + 0.5*2726*0.15*r_e^2 ...
    + 0.25*8252*0.1*r_e^2 + 0.5*8252*0.1*r_e^2 + 0.08*7633*0.2*r_e^2);


%Operator mass and weight
m_operator = 100; %kg
W_operator = m_operator*g; %N

%Device mass and weight
%m_device = 100;
W_device = n*m_device*g;

%Totat mass and acceleration 
m_tot = m_operator + m_device;
F_tot = n*F_gen;
a = F_tot/m_tot;




%% PLOTS
% figure(1);
% title('Exit radius vs. Generated Thrust');
% plot(r_e,F_gen,'-x');
% xlabel('Exit radius [m]');
% ylabel('Thrust generated [N]');
% hold on;
% grid on;

% figure(2);
% plot(r_i,F_gen,'-x');
% title('Inlet radius vs. Generated Thrust');
% xlabel('Inlet radius [m]');
% ylabel('Thrust generated [N]');
% hold on;
% grid on;

% figure(3);
% plot(ratio_c,F_gen,'-x');
% title('Compressor pressure ratio vs. Generated Thrust');
% xlabel('Compressor pressure ratio');
% ylabel('Thrust generated [N]');
% hold on;
% grid on;

% figure(4);
% plot(V_user,F_gen,'-x');
% title('Forward air speed vs. Generated Thrust');
% xlabel('Air speed [m/s]');
% ylabel('Thrust generated [N]');
% hold on;
% grid on;



%end


%end


%end

%end
