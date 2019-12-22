%% Quadrotor Propeller Performance
clear
clc

% Propeller Database
directory = 'C:\Users\Mahal\Documents\AerospaceEng\AER1216 UAVs\UIUC-propDB\volume-1\data\';   
fileList = dir(fullfile(directory, '*static*.txt'));
str = {fileList.name}';

%Prop diameter
D1 = extractAfter(str,"_");
D2 = extractBefore(D1,"x");
Diam = convlength(str2double(D2),'in','m');

% Static Thrust
T_static = 10; %N
% Air Density
rho = 1.225; %kg/m^3

for i=1:1:size(Diam)
    
% Importing data
filename = insertAfter(directory,'data\',str(i,1));
dataStructure = importdata(filename);
prop_data = dataStructure.data;
% Arranging data
rpm_static(:,i) = prop_data(:,1);
rps_static(:,i) = rpm_static(:,i) / 60;
CT_static(:,i) = prop_data(:,2);
CP_static(:,i) = prop_data(:,3);


for rps=15:1:500
CT = interp1(rps_static(:,i),CT_static(:,i),rps,'linear','extrap');
T = CT * rps^2 * rho * Diam(i,1).^4 ;
if ( T_static - 0.5 < T && T < T_static + 0.5)
    rps_req(:,i) = rps;
end
end

CP = interp1(rps_static(:,i),CP_static(:,i),rps_req(:,i),'linear','extrap');
if (CP < 0)
    CP = 0.00001;
end
P_req(:,i) = CP * rps_req(:,i)^3 * rho * Diam(i,1).^5 ;
Q_req(:,i) = P_req(i)/(rps_req(:,i)*2*pi);

j(:,i) = i;

end

% PLOTS
% figure()
% plot(j,P_req,'Marker', '+', 'MarkerSize', 4, ...
%    'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')
% grid on;
% xlabel('Prop Index');
% ylabel('Power Required [W] for T = 10 N');
% 
% figure()
% plot(j,Q_req,'Marker', '+', 'MarkerSize', 4, ...
%    'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')
% grid on;
% xlabel('Prop Index');
% ylabel('Torque Required [Nm] for T = 10 N');
% 
% figure()
% grid on;
% plot(j,rps_req,'Marker', '+', 'MarkerSize', 4, ...
%    'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')
% grid on;
% xlabel('Prop Index');
% ylabel('RPS Required for T = 10 N');

%% Fixed Wing Steady Level Flight

m = 11.5; %kg
g = 9.81; %m/s^2
W = m*g;
rho = [1.225;1.112;1.007;0.9093;0.8194;0.7364]; %kg/m^3 seal level

% Aerodynamics
S = 0.893; %m^2
Cd_0 = 3.29e-02; 
AR = 13.725;
e = 0.7;
K = 1/(pi*AR*e);

% Min power and min thrust required
for a=1:1:3
Cl_tr_min = sqrt(Cd_0/K);
Cl_pr_min = sqrt(3*Cd_0/K);

T_tr_min = 2*sqrt(K*Cd_0)*W;
V_tr_min(a) = sqrt(2*(W/S)/(rho(a)*Cl_tr_min));
P_tr_min(a) = T_tr_min*V_tr_min(a);

P_pr_min(a) = (W/Cl_pr_min)*(4*Cd_0)*sqrt(2*(W/S)/(rho(a)*Cl_pr_min));
V_pr_min(a) = sqrt(2*(W/S)/(rho(a)*Cl_pr_min));
T_pr_min = P_pr_min(a) / V_pr_min(a);
end

j = 1;
for a=1:1:3
for v=7:1:35
q(j,a) = 0.5*rho(a)*v^2;
Cl(j,a) = W/(q(j,a)*S);
Cd(j,a) = Cd_0 + K*Cl(j,a)^2;
D(j,a) = Cd(j,a)*q(j,a)*S;
v_kmh(j,a) = v*3.6;
Preq(j,a) = D(j,a)*v;
L_D(j,a) = Cl(j,a)/Cd(j,a);   

j = j + 1;
end
j = 1;
[T_min(:,a),i_tmin] = min(D(:,a));
[P_min(:,a),i_pmin] = min(Preq(:,a));

v_tmin(:,a) = v_kmh(i_tmin,a);
v_pmin(:,a) = v_kmh(i_pmin,a);

end

% L/D curve
figure()
plot(Cl(:,1),L_D(:,1),'-');
grid on;
xlabel('Cl');
ylabel('L/D');

% Thrust required at specified speed
figure()
plot(v_kmh(:,1),D(:,1));
grid on;
xlabel('Velocity [km/h]');
ylabel('Thrust Req [N]');
legend('Sea Level');

%Power required at specified speed
figure()
plot(v_kmh(:,1),Preq(:,1));
grid on;
xlabel('Velocity [km/h]');
ylabel('Power Req [W]');
legend('Sea Level');

% Drag Polar
figure()
plot(Cd(:,1),Cl(:,1))
grid on;
xlabel('Cd');
ylabel('Cl');


%% Pusher Prop Performance

% APC 19x10 DATA 
% directory = 'C:\Users\Mahal\Documents\AerospaceEng\AER1216 UAVs\19x10_prop_data\';
% fileList = dir(fullfile(directory, '*000.txt*'));
% str1 = {fileList.name}';
% str2 = '19x10_prop_data\';
% 
% [V,J,Pe,Ct,Cp,Pwr,Torque,Thrust] = propPerformance(str1,str2,directory);

%% 
% APC 20x10 DATA
% directory = 'C:\Users\Mahal\Documents\AerospaceEng\AER1216 UAVs\20x10_prop_data\';
% fileList = dir(fullfile(directory, '*000.txt*'));
% str1 = {fileList.name}';
% str2 = '20x10_prop_data\';
% 
% [V,J,Pe,Ct,Cp,Pwr,Torque,Thrust] = propPerformance(str1,str2,directory);

%% 
% APC 20x8 DATA

% directory = 'C:\Users\Mahal\Documents\AerospaceEng\AER1216 UAVs\20x8_prop_data\';
% fileList = dir(fullfile(directory, '*000.txt*'));
% str1 = {fileList.name}';
% str2 = '20x8_prop_data\';
% 
% [V,J,Pe,Ct,Cp,Pwr,Torque,Thrust] = propPerformance(str1,str2,directory);

%%
% APC 19x12 DATA

directory = 'C:\Users\Mahal\Documents\AerospaceEng\AER1216 UAVs\19x12_prop_data\';
fileList = dir(fullfile(directory, '*000.txt*'));
str1 = {fileList.name}';
str2 = '19x12_prop_data\';

[V,J,Pe,Ct,Cp,Pwr,Torque,Thrust] = propPerformance(str1,str2,directory);


%% Pusher Electric Motor Performance

Kv_rpm = 210; %rpm/V
i0 = 1.11; %amps
R = 0.026; %ohms
Volt_max = 22.2;

[rpm,current,Qm,P_shaft,P_elec,eff_m] = electriMotorPerformance(Kv_rpm,i0,R,Volt_max);

%% Power and Thrust Available

i = 1;
for Volt=15.2:1:22.2 %Volts
    V_matched_cr = Volt;
    
    if (V_matched_cr < 18)
        speed_max = 100;
    end
    
    if (18 < V_matched_cr && V_matched_cr < 19)
        speed_max = 100;
    end
    
    if (V_matched_cr > 20)
        speed_max = 120;
    end
    j = 1;
    for speed=35:10:speed_max %km/h
    V_target = speed;

        
[T_avail(j,i)] = thrustAvailable(V,Pe,Pwr,Torque,Thrust,V_target,...
    Kv_rpm,i0,R,...
    V_matched_cr);

    T_avail_vel(j,i) = speed;
    P_avail(j,i) = speed/3.6 * T_avail(j,i);
    
    j = j + 1;
    end
    i = i + 1;    
end
T_avail(T_avail==0)=NaN;
T_avail_vel(T_avail_vel==0)=NaN;

figure()
plot(v_kmh(:,1),D(:,1),T_avail_vel,T_avail);
grid on;
xlabel('Speed [km/h]');
ylabel('T [N]');
legend('Thrust required');

figure()
plot(v_kmh(:,1),Preq(:,1),T_avail_vel,P_avail);
grid on;
xlabel('Speed [km/h]');
ylabel('P [W]');
legend('Power required');


%% Matching RPM at different speeds @ SEA LEVEL

V_cruise = 89;
Treq_level = interp1(v_kmh(:,1),D(:,1),V_cruise,'linear');

T_req_target = [Treq_level,Treq_level,Treq_level];
V_target = [V_cruise,V_cruise,V_cruise ];

[Preq_level,Preq_tr_min,Preq_pr_min, ...
    V_matched_cr,V_matched_tr_min,V_matched_pr_min,...
    prop_eff_matched_cr,prop_eff_matched_pr_min,prop_eff_matched_tr_min,...
    motor_eff_matched_cr,motor_eff_matched_pr_min,motor_eff_matched_tr_min]...
= determinePropMotorSystem(V,Pe,Pwr,Torque,Thrust,Kv_rpm,i0,R,T_req_target,V_target);

%% Pusher Endurance and Range @ SEA LEVEL

Rt = 1; %battery hour rating
C = 14; %Ah
n = 1; %typical li-poly battery

n_tot_cr = prop_eff_matched_cr*motor_eff_matched_cr;
n_tot_tr_min = prop_eff_matched_tr_min*motor_eff_matched_tr_min;
n_tot_pr_min = prop_eff_matched_pr_min*motor_eff_matched_pr_min;

U_cr = V_cruise/3.6;

[R_cr, E_cr] = rangeAndEndurance(Rt,C,V_matched_cr,n_tot_cr,n,Preq_level,U_cr);
[R_tr, E_tr] = rangeAndEndurance(Rt,C,V_matched_tr_min,n_tot_tr_min,n,Preq_tr_min,V_tr_min(:,1));
[R_pr, E_pr] = rangeAndEndurance(Rt,C,V_matched_pr_min,n_tot_pr_min,n,Preq_pr_min,V_pr_min(:,1));

Range = [R_cr;R_tr;R_pr];
E = [E_cr;E_tr;E_pr];
table(Range,E,'RowNames',{'Cruise';'T min';'P min'})

% 
temp_factor = 0.7; % 0 degC
C_0degC = temp_factor * C;

[R_cr_0degC, E_cr_0degC] = rangeAndEndurance(Rt,C_0degC,V_matched_cr,n_tot_cr,n,Preq_level,U_cr);
[R_tr_0degC, E_tr_0degC] = rangeAndEndurance(Rt,C_0degC,V_matched_tr_min,n_tot_tr_min,n,Preq_tr_min,V_tr_min(:,1));
[R_pr_0degC, E_pr_0degC] = rangeAndEndurance(Rt,C_0degC,V_matched_pr_min,n_tot_pr_min,n,Preq_pr_min,V_pr_min(:,1));

Range_0degC = [R_cr_0degC;R_tr_0degC;R_pr_0degC];
E_0degC = [E_cr_0degC;E_tr_0degC;E_pr_0degC];
table(Range_0degC,E_0degC,'RowNames',{'Cruise';'T min';'P min'})

%% Matching RPM at different speeds @ 1KM

V_cruise = 81;
Treq_level = interp1(v_kmh(:,2),D(:,2),V_cruise,'linear');

T_req_target = [T_tr_min,T_pr_min,Treq_level];
V_target = [V_tr_min(2)*3.6,V_pr_min(2)*3.6,V_cruise];

[Preq_level,Preq_tr_min,Preq_pr_min, ...
    V_matched_cr,V_matched_tr_min,V_matched_pr_min,...
    prop_eff_matched_cr,prop_eff_matched_pr_min,prop_eff_matched_tr_min,...
    motor_eff_matched_cr,motor_eff_matched_pr_min,motor_eff_matched_tr_min]...
= determinePropMotorSystem(V,Pe,Pwr,Torque,Thrust,Kv_rpm,i0,R,T_req_target,V_target);


%% Pusher Endurance and Range @ 1 KM

Rt = 1; %battery hour rating
n_tot_cr = prop_eff_matched_cr*motor_eff_matched_cr;
n_tot_tr_min = prop_eff_matched_tr_min*motor_eff_matched_tr_min;
n_tot_pr_min = prop_eff_matched_pr_min*motor_eff_matched_pr_min;

C = 10; %Ah

n = 1; %typical li-poly battery

U_cr = V_cruise/3.6;

[R_cr,E_cr] = rangeAndEndurance(Rt,C,V_matched_cr,n_tot_cr,n,Preq_level,U_cr);
[R_tr,E_tr] = rangeAndEndurance(Rt,C,V_matched_tr_min,n_tot_tr_min,n,Preq_tr_min,V_tr_min(:,2));
[R_pr,E_pr] = rangeAndEndurance(Rt,C,V_matched_pr_min,n_tot_pr_min,n,Preq_pr_min,V_pr_min(:,2));

Range = [R_cr;R_tr;R_pr];
E = [E_cr;E_tr;E_pr];
table(Range,E,'RowNames',{'Cruise';'T min';'P min'})

%% Hover Prop Performance

clear
clc
%% 
% APC 16x10 DATA 
% directory = 'C:\Users\Mahal\Documents\AerospaceEng\AER1216 UAVs\16x10_prop_data\';
% fileList = dir(fullfile(directory, '*.txt*'));
% str1 = {fileList.name}';
% str2 = '16x10_prop_data\';
% 
% prop_d = 16;

[V,J,Pe,Ct,Cp,Pwr,Torque,Thrust] = propPerformance(str1,str2,directory);
%% 
% APC 16x8 DATA
% directory = 'C:\Users\Mahal\Documents\AerospaceEng\AER1216 UAVs\16x8_prop_data\';
% fileList = dir(fullfile(directory, '*.txt*'));
% str1 = {fileList.name}';
% str2 = '16x8_prop_data\';
% 
% prop_d = 16;
% 
% [V,J,Pe,Ct,Cp,Pwr,Torque,Thrust] = propPerformance(str1,str2,directory);

%% 
% APC 16x6 DATA
% directory = 'C:\Users\Mahal\Documents\AerospaceEng\AER1216 UAVs\16x6_prop_data\';
% fileList = dir(fullfile(directory, '*.txt*'));
% str1 = {fileList.name}';
% str2 = '16x6_prop_data\';
% 
% prop_d = 16;
% 
% [V,J,Pe,Ct,Cp,Pwr,Torque,Thrust] = propPerformance(str1,str2,directory);
%% 
% APC 15x6 DATA

directory = 'C:\Users\Mahal\Documents\AerospaceEng\AER1216 UAVs\15x6_prop_data\';
fileList = dir(fullfile(directory, '*.txt*'));
str1 = {fileList.name}';
str2 = '15x6_prop_data\';

prop_d = 15;

[V,J,Pe,Ct,Cp,Pwr,Torque,Thrust] = propPerformance(str1,str2,directory);

%% Hover Electric Motor Performance

Kv_rpm = 250; %rpm/V
i0 = 0.69; %amps
R = 0.037; %ohms
Volt_max = 35;

[rpm,current,Qm,P_shaft,P_elec,eff_m] = electriMotorPerformance(Kv_rpm,i0,R,Volt_max);

%% Hover Performance 

m = 11.5; %kg
g = 9.81; %m/s^2
W = m*g;

diam = prop_d * (2.54/100); % m
A = pi*(diam/2)^2;

Th = W/4;

for i=1:1:13
rpm_hover(i) = i*1000;
end

T_0 = Thrust(1,:);
T_0 = T_0([1 6:13 2:5]);

Pin_0 = Pwr(1,:);
Pin_0 = Pin_0([1 6:13 2:5]);

eff_0 = Pe(1,:);
eff_0 = eff_0([1 6:13 2:5]);

Torque_0 = Torque(1,:);
Torque_0 = Torque_0([1 6:13 2:5]);

rpm_needed_hover = interp1(T_0,rpm_hover,Th,'linear');
T_needed_hover = Th;
P_in_needed_hover = interp1(rpm_hover,Pin_0,rpm_needed_hover,'linear');
Torque_hover = interp1(rpm_hover,Torque_0,rpm_needed_hover,'linear');

figure()
plot(rpm_hover,T_0)
grid on;
x = [0 rpm_needed_hover rpm_needed_hover rpm_needed_hover]; %manually done
y = [T_needed_hover T_needed_hover 0 0];
line(x,y,'Color','red','LineStyle','--')
ylabel('T [N]');
xlabel('RPM');
txt = join(['  [',num2str(rpm_needed_hover),', ',num2str(T_needed_hover),']']);
text(rpm_needed_hover,T_needed_hover,txt);
legend('Thrust generated @ 0 km/h');


figure()
plot(rpm_hover,Pin_0)
grid on;
xlabel('RPM');
ylabel('Power in [W]');
x = [0 rpm_needed_hover rpm_needed_hover rpm_needed_hover]; %manually done
y = [P_in_needed_hover P_in_needed_hover 0 0];
line(x,y,'Color','red','LineStyle','--')
txt = join(['  [',num2str(rpm_needed_hover),', ',num2str(P_in_needed_hover),']']);
text(rpm_needed_hover,P_in_needed_hover,txt);
legend('Power in @ 0 km/h');



%% Matching Hover RPM and motor efficiency, max thrust

Kv_rad = Kv_rpm*(2*pi)/60; %rad/s/V
Volt_max = 37;

i = 1;
for Volt=5:0.1:Volt_max
for rad=1:1:1000
rpm(rad,i) = rad*60/(2*pi);
P_shaft(rad,i) = ((1/R)*(Volt - rad/Kv_rad) - i0)*(rad/Kv_rad);
eff_m(rad,i) = (1 - ((i0*R)/(Volt - rad/Kv_rad)))*(rad/(Volt*Kv_rad));
current(rad,i) = (Volt - rad/Kv_rad)*(1/R);
Qm(rad,i) = ((Volt - rad/Kv_rad )*(1/R) - i0)*(1/Kv_rad);
if (eff_m(rad,i) > 1)
    eff_m(rad,i) = 0;
end

end

dP = P_in_needed_hover - P_shaft(round(rpm_needed_hover*2*pi/60),i);
dQ = Torque_hover - Qm(round(rpm_needed_hover*2*pi/60),i);

if (abs(dP) < 5 || abs(dQ) < 0.05)
    index_volt = i;
    V_needed_hover = Volt;
end

i = i + 1;
end

Torque_hover = interp1(rpm_hover,Torque_0,rpm_needed_hover,'linear');

figure()
plot(rpm_hover,Torque_0,...
    rpm(:,index_volt),Qm(:,index_volt))
ylim([0 2]);
xlim([rpm_needed_hover-1000 rpm_needed_hover+1000]);
xlabel('RPM');
ylabel('Torque [Nm]');
grid on;
x = [0 rpm_needed_hover rpm_needed_hover rpm_needed_hover]; %manually done
y = [Torque_hover Torque_hover 0 0];
line(x,y,'Color','red','LineStyle','--')
txt = join(['  [',num2str(rpm_needed_hover),', ',num2str(Torque_hover),']']);
text(rpm_needed_hover,Torque_hover,txt);
txtl = join(['Motor torque @',num2str(V_needed_hover),' Volts']);
legend('Torque required for propeller @ 0 km/h',...
    txtl);

i_needed_hover = interp1(rpm(:,index_volt),current(:,index_volt),rpm_needed_hover,'linear');

figure()
plot(rpm(:,index_volt),current(:,index_volt))
grid on;
ylim([0,100]);
xlim([rpm_needed_hover - 1000,rpm_needed_hover + 2000]);
xlabel('Motor Speed [rpm]');
ylabel('Current [amps]');
x = [0 rpm_needed_hover rpm_needed_hover rpm_needed_hover]; %manually done
y = [i_needed_hover i_needed_hover 0 0];
line(x,y,'Color','red','LineStyle','--')
txt = join([ '  [',num2str(rpm_needed_hover),',',num2str(i_needed_hover),']']);
text(rpm_needed_hover,i_needed_hover,txt);
txtl = join(['Current @',num2str(V_needed_hover),' Volts']);
legend(txtl);


figure()
plot(rpm(:,index_volt),P_shaft(:,index_volt))
grid on;
ylim([0,max(P_shaft(:,index_volt))]);
xlim([0,rpm_needed_hover + 2000]);
xlabel('Motor Speed [rpm]');
ylabel('Shaft Power [W]');
x = [0 rpm_needed_hover rpm_needed_hover rpm_needed_hover]; %manually done
y = [P_in_needed_hover P_in_needed_hover 0 0];
line(x,y,'Color','red','LineStyle','--')
txt = join([ '  [',num2str(rpm_needed_hover),',',num2str(P_in_needed_hover),']']);
text(rpm_needed_hover,P_in_needed_hover,txt);
txtl = join(['Shaft Power @',num2str(V_needed_hover),' Volts']);
legend(txtl);

eff_m_hover = interp1(rpm(:,index_volt),eff_m(:,index_volt),rpm_needed_hover,'linear');

figure()
plot(rpm(:,index_volt),eff_m(:,index_volt))
grid on;
ylim([0,1.2]);
xlabel('Motor Speed [rpm]');
ylabel('Efficiency');
x = [0 rpm_needed_hover rpm_needed_hover rpm_needed_hover]; %manually done
y = [eff_m_hover eff_m_hover 0 0];
line(x,y,'Color','red','LineStyle','--')
txt = join([ '  [',num2str(rpm_needed_hover),',',num2str(eff_m_hover),']']);
text(rpm_needed_hover,eff_m_hover,txt);
txtl = join(['Motor Eff @',num2str(V_needed_hover),' Volts']);
legend(txtl);

% maximum thrust

Volt_max = 37;
index_max = length(rpm(1,:));

for rad=1:1:1000
rpm(rad) = rad*60/(2*pi);
Qp = interp1(rpm_hover,Torque_0,rpm(rad),'linear');
dQ = Qm(rad,index_max) -  Qp;
if ( abs(dQ) < 0.02 )
    rpm_max_t = rpm(rad);
    max_Q = Qm(rad,index_max);
end
end

plot(rpm(:,index_max),Qm(:,index_max),rpm_hover,Torque_0)
ylim([0 max(Torque_0)]);
grid on;
xlabel('RPM');
ylabel('Torque [Nm]');
x = [0 rpm_max_t rpm_max_t rpm_max_t]; %manually done
y = [max_Q max_Q 0 0];
line(x,y,'Color','red','LineStyle','--');
set(get(get(line,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
txt = join(['[',num2str(rpm_max_t),',',num2str(max_Q),']']);
text(rpm_max_t,max_Q,txt);
legend('Motor Torque @ 37 Volts','Prop Torque @ 0 km/h');

i_level = interp1(rpm(:,index_max),current(:,index_max),rpm_max_t,'linear');

figure()
plot(rpm,current(:,index_max)); %matched index
grid on;
xlim([rpm_max_t-1000 rpm_max_t+1000]);
ylim([0 i_level+15]);
xlabel('RPM');
ylabel('Current [amps]');
    % cruise
x = [0 rpm_max_t rpm_max_t rpm_max_t]; %manually done
y = [i_level i_level 0 0];
line(x,y,'Color','red','LineStyle','--')
set(get(get(line,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
txt1 = join(['Current @ ~',num2str(Volt_max),' Volts']);
legend(txt1);
txt = join(['[',num2str(rpm_max_t),',',num2str(i_level),']']);
text(rpm_max_t,i_level,txt);
% 

P_max_t = interp1(rpm(:,1),P_shaft(:,index_max),rpm_max_t,'linear');

figure()
plot(rpm(:,1),P_shaft(:,index_max),rpm_hover,Pin_0) 
grid on;
ylim([0,max(max(P_shaft))]);
xlabel('Motor Speed [rpm]');
ylabel('Shaft Power [W]');
x = [0 rpm_max_t rpm_max_t rpm_max_t]; %manually done
y = [P_max_t P_max_t 0 0];
line(x,y,'Color','red','LineStyle','--')
set(get(get(line,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
txt = join(['  [',num2str(rpm_max_t),', ',num2str(P_max_t),']']);
text(rpm_max_t,P_max_t,txt);
txtl = join(['Shaft Power @',num2str(Volt_max),' Volts']);
txt2 = 'Prop Power In @ 0 km/h';
legend(txtl,txt2);

T_max = interp1(rpm_hover,T_0,rpm_max_t,'linear');

figure()
plot(rpm_hover,T_0)
grid on;
x = [0 rpm_max_t rpm_max_t rpm_max_t];
y = [T_max T_max 0 0];
line(x,y,'Color','red','LineStyle','--')
xlabel('RPM');
ylabel('T [N]');
txt = join(['  [',num2str(rpm_max_t),', ',num2str(T_max),']']);
text(rpm_max_t,T_max,txt);
txtl = 'Prop Thrust @ 0 km/h';
legend(txtl);

eff_m_max = interp1(rpm(:,index_max),eff_m(:,index_max),rpm_max_t,'linear');

figure()
plot(rpm(:,index_max),eff_m(:,index_max))
grid on;
ylim([0,1.2]);
xlim([0,rpm_max_t + 3000]);
xlabel('Motor Speed [rpm]');
ylabel('Efficiency');
x = [0 rpm_max_t rpm_max_t rpm_max_t]; %manually done
y = [eff_m_max eff_m_max 0 0];
line(x,y,'Color','red','LineStyle','--')
txt = join([ '  [',num2str(rpm_max_t),',',num2str(eff_m_max),']']);
text(rpm_max_t,eff_m_max,txt);
txtl = join(['Motor Eff @',num2str(Volt_max),' Volts']);
legend(txtl);


Hover_v = V_needed_hover / Volt_max;
Hover_t = Th / T_max;
Hover_p = P_in_needed_hover / P_max_t;

H_percent = [Hover_v;Hover_t;Hover_p];

table(H_percent,'variableName',{'Percent'},'rowNames',{'Volt','T','P'})

max_g = T_max/Th - 1;
W_A_h = Th/A;
W_A_max= T_max/A;

W_A = [max_g;W_A_h;W_A_max];

table(W_A,'variableName',{'Ratio'},...
    'rowNames',{'Max initial g','W/A hover [N/m^2]','W/A max [N/m^2]'})

%% KDE DATA

% 15.5 x 5.3

throttle = [25;37.5;50;62.5;75;87.5;100];
amps = [1.6;3.7;6.8;11.2;16.8;24.2;30.6];
pwr = [55;128;236;309;584;842;1064];
Thrust = [5.98;11.38;17.85;24.12;32.17;40.01;48.94];
rpm = [3300;4580;5600;6600;7500;8400;9120];
eff_m = [11.09;9.06;7.71;6.43;5.62;4.85;4.69];
grams_t = [610;1160;1820;2500;3280;4080;4990];

rpm_needed_hover = interp1(Thrust,rpm,Th,'linear');
amps_needed_hover = interp1(rpm,amps,rpm_needed_hover,'linear');
pwr_needed_hover = interp1(rpm,pwr,rpm_needed_hover,'linear');
grams_h = interp1(rpm,grams_t,rpm_needed_hover,'linear');
eff_m_hover = interp1(rpm,eff_m,rpm_needed_hover,'linear') / grams_h * pwr_needed_hover;
throttle_h = interp1(rpm,throttle,rpm_needed_hover,'linear');


table(rpm_needed_hover,amps_needed_hover,pwr_needed_hover,...
   eff_m_h,throttle_h)

%% Hover Endurance

Rt = 1; %battery hour rating
n_tot_h = eff_m_hover;

C = 4.5; %Ah
n = 1; %typical li-poly battery

U_h = 0;

[R_h,E_h] = rangeAndEndurance(Rt,C,Volt_max,n_tot_h,n,(P_in_needed_hover*4),U_h);

Range = R_h;
E = E_h;
table(Range,E,'RowNames',{'Hover'})

