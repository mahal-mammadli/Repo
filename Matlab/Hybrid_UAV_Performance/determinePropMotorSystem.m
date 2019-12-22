function[Preq_level,Preq_tr_min,Preq_pr_min, ...
    V_matched_cr,V_matched_tr_min,V_matched_pr_min,...
    prop_eff_matched_cr,prop_eff_matched_pr_min,prop_eff_matched_tr_min,...
    motor_eff_matched_cr,motor_eff_matched_pr_min,motor_eff_matched_tr_min]...
    = determinePropMotorSystem(V,Pe,Pwr,Torque,Thrust,...
    Kv_rpm,i0,R,T_req_target,V_target)

T_tr_min = T_req_target(1);
T_pr_min = T_req_target(2);
Treq_level = T_req_target(3);
    
V_tr_min = V_target(1);
V_pr_min = V_target(2);
V_cruise = V_target(3);

[vel,...
        thrust_tr_min,thrust_pr_min,thrust_cr,...
        power_tr_min,power_pr_min,power_cr,...
        eff_tr_min,eff_pr_min,eff_cr,...
        Q_p_tr_min,Q_p_pr_min,Q_p_cr,...
        rpm_tr_min,rpm_pr_min,rpm_cr] = extractPropDataAtSpeed(V,Pe,Pwr,Torque,Thrust,V_target);

[rpm_matched_volt,current_matched_volt,Qm_matched_volt,...
    eff_m_matched_volt,P_shaft_matched_volt] = estimateMotorPerf(Kv_rpm,i0,R);

[rpm_needed,rpm_needed_tr_min,rpm_needed_pr_min] = matchThrustAndRpm(vel,...
    Treq_level,T_tr_min,T_pr_min,...
        thrust_tr_min,thrust_pr_min,thrust_cr,...
        rpm_tr_min,rpm_pr_min,rpm_cr);

[V_matched_cr,V_matched_tr_min,V_matched_pr_min,...
        v_index_cr,v_index_tr_min,v_index_pr_min] = torqueMatchPropMotorAtRpm(vel,...
        rpm_matched_volt,Qm_matched_volt,...
        rpm_cr,Q_p_cr,...
        rpm_pr_min,Q_p_pr_min,...
        rpm_tr_min,Q_p_tr_min,...        
        rpm_needed,rpm_needed_tr_min,rpm_needed_pr_min);

[prop_eff_matched_cr,prop_eff_matched_pr_min,prop_eff_matched_tr_min,...
    motor_eff_matched_cr,motor_eff_matched_pr_min,motor_eff_matched_tr_min] ...
    = motorAndPropEff(vel,...
    V_matched_cr,V_matched_tr_min,V_matched_pr_min,...
    v_index_cr,v_index_tr_min,v_index_pr_min,...
    rpm_needed,rpm_needed_tr_min,rpm_needed_pr_min,...
    eff_m_matched_volt,rpm_matched_volt,...
    eff_cr,eff_tr_min,eff_pr_min,...
    rpm_cr,rpm_tr_min,rpm_pr_min)

[Preq_level,Preq_tr_min,Preq_pr_min] = determinePwr(vel,...
    V_matched_cr,V_matched_tr_min,V_matched_pr_min,...
    v_index_cr,v_index_tr_min,v_index_pr_min,...
    rpm_needed,rpm_needed_tr_min,rpm_needed_pr_min,...
    P_shaft_matched_volt,rpm_matched_volt,...
    rpm_cr,rpm_tr_min,rpm_pr_min,...
    power_tr_min,power_pr_min,power_cr)

[i_level,i_tr_min,i_pr_min] = determineCurrent(...
    V_matched_cr,V_matched_tr_min,V_matched_pr_min,...
    v_index_cr,v_index_tr_min,v_index_pr_min,...
    rpm_needed,rpm_needed_tr_min,rpm_needed_pr_min,...
    current_matched_volt,rpm_matched_volt)


end

function[vel,...
        thrust_tr_min,thrust_pr_min,thrust_cr,...
        power_tr_min,power_pr_min,power_cr,...
        eff_tr_min,eff_pr_min,eff_cr,...
        Q_p_tr_min,Q_p_pr_min,Q_p_cr,...
        rpm_tr_min,rpm_pr_min,rpm_cr] = extractPropDataAtSpeed(V,Pe,Pwr,Torque,Thrust,V_target)


hit = 0;
k = 0;
j_max = length(V(1,:));

for m=1:1:3
for j=1:1:j_max
    for i=1:1:30
        if (V_target(m)-5 < V(i,j) && V(i,j) < V_target(m)+5 && hit ~= 1) % +- 2 km/h tolerance
            switch j
                case 1
                    k = 1;
                    p_rpm(m,k) = 1000;
                case 2
                    k = 10;
                    p_rpm(m,k) = 10000;
                case 3
                    k = 11;
                    p_rpm(m,k) = 11000;
                case 4
                    k = 12;
                    p_rpm(m,k) = 12000;
                case 5
                    k = 2;
                    p_rpm(m,k) = 2000;
                case 6
                    k = 3;
                    p_rpm(m,k) = 3000;
                case 7
                    k = 4;
                    p_rpm(m,k) = 4000;
                case 8
                    k = 5;
                    p_rpm(m,k) = 5000;
                case 9
                    k = 6;
                    p_rpm(m,k) = 6000;
                case 10
                    k = 7;
                    p_rpm(m,k) = 7000;
                case 11
                    k = 8;
                    p_rpm(m,k) = 8000;
                case 12
                    k = 9;
                    p_rpm(m,k) = 9000;                
            end
            
            Q_p(m,k) = Torque(i,j);
            eff_p(m,k) = Pe(i,j);
            thrust_p(m,k) = Thrust(i,j);
            power_in(m,k) = Pwr(i,j);
            vel(m,k) = V(i,j);
  
            hit = 1;
        end
    end
    hit = 0;
    
end
end

% Correcting index
    % torque
Q_p_tr_min = nonzeros(Q_p(1,:));
Q_p_pr_min = nonzeros(Q_p(2,:));
Q_p_cr = nonzeros(Q_p(3,:));
    % rpm
rpm_tr_min = nonzeros(p_rpm(1,:));
rpm_pr_min = nonzeros(p_rpm(2,:));
rpm_cr = nonzeros(p_rpm(3,:));
    % eff
eff_tr_min = nonzeros(eff_p(1,:));
eff_pr_min = nonzeros(eff_p(2,:));
eff_cr = nonzeros(eff_p(3,:));
    % thrust
thrust_tr_min = nonzeros(thrust_p(1,:));
thrust_pr_min = nonzeros(thrust_p(2,:));
thrust_cr = nonzeros(thrust_p(3,:));
    % power
power_tr_min = nonzeros(power_in(1,:));
power_pr_min = nonzeros(power_in(2,:));
power_cr = nonzeros(power_in(3,:));
    % avg speed of iterated data
vel_avg_tr_min = mean(nonzeros((vel(1,:))));
vel_avg_pr_min = mean(nonzeros((vel(2,:))));
vel_avg_cr = mean(nonzeros((vel(3,:))));

%outputs

vel = [vel_avg_tr_min;vel_avg_pr_min;vel_avg_cr];

end

function[rpm_matched_volt,current_matched_volt,Qm_matched_volt,...
    eff_m_matched_volt,P_shaft_matched_volt] = estimateMotorPerf(Kv_rpm,i0,R)

% Iterating optimal operating voltage for motor during cruise
Kv_rad = Kv_rpm*2*pi/60; %rad/s/V
i = 1;
for Volt=0:0.05:37
for rad=1:1:1000
rpm_matched_volt(rad,i) = rad*60/(2*pi);
current_matched_volt(rad,i) = (Volt - rad/Kv_rad)*(1/R);
Qm_matched_volt(rad,i) = ((Volt - rad/Kv_rad )*(1/R) - i0)*(1/Kv_rad);
eff_m_matched_volt(rad,i) = (1 - ((i0*R)/(Volt - rad/Kv_rad)))*(rad/(Volt*Kv_rad));
P_shaft_matched_volt(rad,i) = ((Volt - rad/Kv_rad)*(1/R) - i0)*(rad/Kv_rad);
end
i = i + 1;
end

end

function[rpm_needed,rpm_needed_tr_min,rpm_needed_pr_min] = matchThrustAndRpm(vel,...
    Treq_level,T_tr_min,T_pr_min,...
        thrust_tr_min,thrust_pr_min,thrust_cr,...
        rpm_tr_min,rpm_pr_min,rpm_cr)

% Thrust mathching at cruise
    %manually interpolated from T vs rpm chart
    
rpm_needed = interp1(thrust_cr,rpm_cr,Treq_level,'linear');
rpm_needed_tr_min = interp1(thrust_tr_min,rpm_tr_min,T_tr_min,'linear');
rpm_needed_pr_min = interp1(thrust_pr_min,rpm_pr_min,T_pr_min,'linear');


figure()
plot(rpm_cr,thrust_cr)
grid on;
xlim([rpm_needed-1000 rpm_needed + 2000]);
ylim([0 25]);
%
str = ['[',num2str(rpm_needed),',',num2str(Treq_level),']'];
txt = join(str);
text(rpm_needed,Treq_level,txt);
    % cruise
x = [0 rpm_needed rpm_needed rpm_needed];   % manually interpolated
y = [Treq_level Treq_level 0 Treq_level];
line(x,y,'Color','red','LineStyle','--')
txt_cr = join(['Cruise (~',num2str(vel(3)),' km/h)']);
legend(txt_cr);
xlabel('RPM');
ylabel('T [N]');

figure()
plot(rpm_tr_min,thrust_tr_min,...
    rpm_pr_min,thrust_pr_min)
grid on;
xlim([0 10000]);
ylim([0 25]);
%
str = ['[',num2str(rpm_needed_tr_min),',',num2str(T_tr_min),']'];
txt = join(str);
text(rpm_needed_tr_min,T_tr_min,txt);
%
str = ['[',num2str(rpm_needed_pr_min),',',num2str(T_pr_min),']'];
txt = join(str);
text(rpm_needed_pr_min,T_pr_min,txt);
%
xlabel('RPM');
ylabel('T generated by prop [N]');
set(get(get(line,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    %tr min
x = [0 rpm_needed_tr_min rpm_needed_tr_min rpm_needed_tr_min];   % manually interpolated
y = [T_tr_min T_tr_min 0 T_tr_min];
line(x,y,'Color','red','LineStyle','--')
    %pr min
x = [0 rpm_needed_pr_min rpm_needed_pr_min rpm_needed_pr_min];   % manually interpolated
y = [T_pr_min T_pr_min 0 T_pr_min];
line(x,y,'Color','red','LineStyle','--')
%
txt_tr= join(['Min T (~',num2str(vel(1)),' km/h)']);
txt_pr = join(['Min P (~',num2str(vel(2)),' km/h)']);

legend(txt_tr,txt_pr);

end


function[V_matched_cr,V_matched_tr_min,V_matched_pr_min,...
        v_index_cr,v_index_tr_min,v_index_pr_min] = torqueMatchPropMotorAtRpm(vel,...
        rpm_matched_volt,Qm_matched_volt,...
        rpm_cr,Q_p_cr,...
        rpm_pr_min,Q_p_pr_min,...
        rpm_tr_min,Q_p_tr_min,...        
        rpm_needed,rpm_needed_tr_min,rpm_needed_pr_min)
% Torque matching at operating point
    % Manually interpolated from findings
        %cruise
    
Q_p_needed_cr = interp1(rpm_cr,Q_p_cr,rpm_needed,'linear');
v_index_max = length(Qm_matched_volt(1,:));
for v_index_cr=1:1:v_index_max

match = Q_p_needed_cr - Qm_matched_volt(round(rpm_needed*2*pi/60),v_index_cr);

if ( -0.05 < abs(match) && abs(match) < 0.05 )
    v_index_cr_match = v_index_cr;
end

end

Q_match_cr = Q_p_needed_cr;    %Nm
v_index_cr = v_index_cr_match;
V_matched_cr = v_index_cr_match*0.05;

figure()
plot(rpm_matched_volt(:,1),Qm_matched_volt(:,v_index_cr_match),...
    rpm_cr,Q_p_cr);
ylim([0.5 1.1]);
xlim([rpm_needed-1000 rpm_needed+1500]);
grid on;

str = ['[',num2str(rpm_needed),',',num2str(Q_match_cr),']'];
txt = join(str);
text(rpm_needed,Q_match_cr,txt);
xlabel('Motor Speed [rpm]');
ylabel('Motor Torque [Nm]');
set(get(get(line,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    % cruise
x = [0 rpm_needed rpm_needed rpm_needed]; %manually done
y = [Q_match_cr Q_match_cr 0 Q_match_cr]; %manually interpolated
line(x,y,'Color','red','LineStyle','--')

txt_cr_m = join(['Motor Torque @',num2str(V_matched_cr),'Volts']);
txt_cr_p = join(['Propeller Torque @ ~',num2str(vel(3)),'km/h']);
legend( txt_cr_m,...
        txt_cr_p');


% % 
Q_match_tr_min = interp1(rpm_tr_min,Q_p_tr_min,rpm_needed_tr_min,'linear');
Q_match_pr_min = interp1(rpm_pr_min,Q_p_pr_min,rpm_needed_pr_min,'linear');
v_index_max = length(Qm_matched_volt(1,:));
for v_index=1:1:v_index_max

match_tr = Q_match_tr_min - Qm_matched_volt(round(rpm_needed_tr_min*2*pi/60),v_index);
match_pr = Q_match_pr_min - Qm_matched_volt(round(rpm_needed_pr_min*2*pi/60),v_index);

% tr
if ( -0.05 < abs(match_tr) && abs(match_tr) < 0.05 )
    v_index_tr_match = v_index;
end

% pr
if ( -0.05 < abs(match_pr) && abs(match_pr) < 0.05 )
    v_index_pr_match = v_index;
end

end

% min power
v_index_pr_min = v_index_pr_match;
V_matched_pr_min = v_index_pr_match*0.05; %Volts
% min thrust
v_index_tr_min = v_index_tr_match;
V_matched_tr_min = v_index_tr_match*0.05; %volts

figure()
plot(rpm_matched_volt(:,1),Qm_matched_volt(:,v_index_tr_min),...
    rpm_tr_min,Q_p_tr_min,...
    rpm_matched_volt(:,1),Qm_matched_volt(:,v_index_pr_min),...
    rpm_pr_min,Q_p_pr_min);
ylim([0.2 0.5]);
xlim([2000 5000]);
grid on;

str = ['[',num2str(rpm_needed_pr_min),',',num2str(Q_match_tr_min),']'];
txt = join(str);
text(rpm_needed_pr_min,Q_match_pr_min,txt);

str = ['[',num2str(rpm_needed_tr_min),',',num2str(Q_match_pr_min),']'];
txt = join(str);
text(rpm_needed_tr_min,Q_match_tr_min,txt);
    % min power
x = [0 rpm_needed_pr_min rpm_needed_pr_min rpm_needed_pr_min]; %manually done
y = [Q_match_pr_min Q_match_pr_min 0 Q_match_pr_min]; %manually interpolated
line(x,y,'Color','red','LineStyle','--')
    % min thrust
x = [0 rpm_needed_tr_min rpm_needed_tr_min rpm_needed_tr_min]; %manually done
y = [Q_match_tr_min Q_match_tr_min 0 Q_match_tr_min]; %manually interpolated
line(x,y,'Color','red','LineStyle','--')

txt1_tr = join(['Motor Torque @ ',num2str(V_matched_tr_min),' Volts']);
txt2_tr = join(['Propeller Torque @',num2str(vel(1)),' km/h']);
txt1_pr = join(['Motor Torque @ ',num2str(V_matched_pr_min),' Volts']);
txt2_pr = join(['Propeller Torque @',num2str(vel(2)),' km/h']);

legend(txt1_tr,txt2_tr,txt1_pr,txt2_pr);

end


function[prop_eff_matched_cr,prop_eff_matched_pr_min,prop_eff_matched_tr_min,...
    motor_eff_matched_cr,motor_eff_matched_pr_min,motor_eff_matched_tr_min] ...
    = motorAndPropEff(vel,...
    V_matched_cr,V_matched_tr_min,V_matched_pr_min,...
    v_index_cr,v_index_tr_min,v_index_pr_min,...
    rpm_needed,rpm_needed_tr_min,rpm_needed_pr_min,...
    eff_m_matched_volt,rpm_matched_volt,...
    eff_cr,eff_tr_min,eff_pr_min,...
    rpm_cr,rpm_tr_min,rpm_pr_min)
% Trimming data set
    % Matched
        % cruise
indices = max(find(eff_m_matched_volt(:,v_index_cr)<1));
rpm_cr_v = rpm_matched_volt(1:indices,v_index_cr); 
eff_m_cr_v = eff_m_matched_volt(1:indices,v_index_cr);
        % min pwr
indices = max(find(eff_m_matched_volt(:,v_index_pr_min)<1));        
rpm_pr_v = rpm_matched_volt(1:indices,v_index_pr_min); 
eff_m_pr_v = eff_m_matched_volt(1:indices,v_index_pr_min);
        % min thrust
indices = max(find(eff_m_matched_volt(:,v_index_tr_min)<1));          
rpm_tr_v = rpm_matched_volt(1:indices,v_index_tr_min);  
eff_m_tr_v = eff_m_matched_volt(1:indices,v_index_tr_min);

% Efficiency matching at operating point
    % cruise
prop_eff_matched_cr = interp1(rpm_cr,eff_cr,rpm_needed,'linear');
motor_eff_matched_cr = interp1(rpm_cr_v,eff_m_cr_v,rpm_needed,'linear');
    % min pwr
prop_eff_matched_pr_min = interp1(rpm_pr_min,eff_pr_min,rpm_needed_pr_min,'linear');
motor_eff_matched_pr_min = interp1(rpm_pr_v,eff_m_pr_v,rpm_needed_pr_min,'linear');
    % min thrust
prop_eff_matched_tr_min = interp1(rpm_tr_min,eff_tr_min,rpm_needed_tr_min,'linear');
motor_eff_matched_tr_min = interp1(rpm_tr_v,eff_m_tr_v,rpm_needed_tr_min,'linear');   

% 1
figure()
plot(rpm_cr_v,eff_m_cr_v,...
        rpm_cr,eff_cr)
ylim([0,1.2]);
xlim([0 12000]);    
        % cruise
txt1 = join(['   [',num2str(rpm_needed),',',num2str(prop_eff_matched_cr),']']);
text(rpm_needed,prop_eff_matched_cr,txt1);
txt2 = join(['   [',num2str(rpm_needed),',',num2str(motor_eff_matched_cr),']']);
text(rpm_needed,motor_eff_matched_cr,txt2);
    % cruise
x = [0 rpm_needed rpm_needed rpm_needed 0]; %manually done
y = [prop_eff_matched_cr prop_eff_matched_cr 0 motor_eff_matched_cr motor_eff_matched_cr];
line(x,y,'Color','red','LineStyle','--')
grid on;
xlabel('Motor Speed [rpm]');
ylabel('Efficiency');
set(get(get(line,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
txt1 = join(['Motor Eff @',num2str(V_matched_cr),' Volts']);
txt2 = join(['Propeller Eff @ ~',num2str(vel(3)),'km/h']);
legend(txt1,txt2);
  

% 2
figure()
plot(rpm_pr_v,eff_m_pr_v,...
     rpm_pr_min,eff_pr_min);
ylim([0,1.2]);
xlim([0 9000]); 
    % min pwr
txt1 = join(['   [',num2str(rpm_needed_pr_min),',',num2str(prop_eff_matched_pr_min),']']);
text(rpm_needed_pr_min,prop_eff_matched_pr_min,txt1);
txt2 = join(['   [',num2str(rpm_needed_pr_min),',',num2str(motor_eff_matched_pr_min),']']);
text(rpm_needed_pr_min,motor_eff_matched_pr_min,txt2);    
    % min pwr
x = [0 rpm_needed_pr_min rpm_needed_pr_min rpm_needed_pr_min 0]; %manually done
y = [prop_eff_matched_pr_min prop_eff_matched_pr_min 0 motor_eff_matched_pr_min motor_eff_matched_pr_min];line(x,y,'Color','red','LineStyle','--')
line(x,y,'Color','red','LineStyle','--')
grid on;
xlabel('Motor Speed [rpm]');
ylabel('Efficiency');
set(get(get(line,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
txt1 = join(['Motor Eff @',num2str(V_matched_pr_min),' Volts']);
txt2 = join(['Propeller Eff @ ~',num2str(vel(2)),'km/h']);
legend(txt1,txt2);

% 3
figure()
plot(rpm_tr_v,eff_m_tr_v,...
    rpm_tr_min,eff_tr_min);
ylim([0,1.1]);
xlim([0 9000]);
    % min thrust
txt1 = join(['   [',num2str(rpm_needed_tr_min),',',num2str(prop_eff_matched_tr_min),']']);
text(rpm_needed_tr_min,prop_eff_matched_tr_min,txt1);
txt2 = join(['   [',num2str(rpm_needed_tr_min),',',num2str(motor_eff_matched_tr_min),']']);
text(rpm_needed_tr_min,motor_eff_matched_tr_min,txt2);       
  % min thrust
x = [0 rpm_needed_tr_min rpm_needed_tr_min rpm_needed_tr_min 0]; %manually done
y = [prop_eff_matched_tr_min prop_eff_matched_tr_min 0 motor_eff_matched_tr_min motor_eff_matched_tr_min];
line(x,y,'Color','red','LineStyle','--')    
grid on;
xlabel('Motor Speed [rpm]');
ylabel('Efficiency');
set(get(get(line,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
txt1 = join(['Motor Eff @',num2str(V_matched_tr_min),' Volts']);
txt2 = join(['Propeller Eff @ ~',num2str(vel(1)),'km/h']);
legend(txt1,txt2);

end

function[Preq_level,Preq_tr_min,Preq_pr_min] = determinePwr(vel,...
    V_matched_cr,V_matched_tr_min,V_matched_pr_min,...
    v_index_cr,v_index_tr_min,v_index_pr_min,...
    rpm_needed,rpm_needed_tr_min,rpm_needed_pr_min,...
    P_shaft_matched_volt,rpm_matched_volt,...
    rpm_cr,rpm_tr_min,rpm_pr_min,...
    power_tr_min,power_pr_min,power_cr)
% Power requirements

Preq_level = interp1(rpm_cr,power_cr,rpm_needed,'linear');

figure()
plot(rpm_cr,power_cr,...
    rpm_matched_volt(:,v_index_cr),P_shaft_matched_volt(:,v_index_cr)); %matched index
grid on;
xlabel('RPM');
ylabel('POWER [W]');
ylim([0 6000]);
    % cruise
x = [0 rpm_needed rpm_needed rpm_needed]; %manually done
y = [Preq_level Preq_level 0 0];
line(x,y,'Color','red','LineStyle','--')
set(get(get(line,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
txt1 = join(['Power Input Required @ ~',num2str(vel(3)),' km/h']);
txt2 = join(['Shaft Power @' ,num2str(V_matched_cr),' Volts']);
legend(txt1,...
     txt2);
txt = join(['[',num2str(rpm_needed),',',num2str(Preq_level),']']);
text(rpm_needed,Preq_level,txt);


% 

Preq_tr_min = interp1(rpm_tr_min,power_tr_min,rpm_needed_tr_min,'linear');
Preq_pr_min = interp1(rpm_pr_min,power_pr_min,rpm_needed_pr_min,'linear');

figure()
plot(rpm_pr_min,power_pr_min,...
    rpm_tr_min,power_tr_min,...
    rpm_matched_volt(:,v_index_pr_min),P_shaft_matched_volt(:,v_index_pr_min),... %matched index
    rpm_matched_volt(:,v_index_tr_min),P_shaft_matched_volt(:,v_index_tr_min)) %matched index
grid on;
xlabel('RPM');
ylabel('POWER [W]');
ylim([0 300]);
xlim([2000 4000]);
    % pwr min
x = [0 rpm_needed_pr_min rpm_needed_pr_min rpm_needed_pr_min]; %manually done
y = [Preq_pr_min Preq_pr_min 0 0];
line(x,y,'Color','red','LineStyle','--')    
    % min thrust
x = [0 rpm_needed_tr_min rpm_needed_tr_min rpm_needed_tr_min]; %manually done
y = [Preq_tr_min Preq_tr_min 0 0];
line(x,y,'Color','red','LineStyle','--')    
set(get(get(line,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
txt1 = join(['Power Input Required @ ~',num2str(vel(2)),' km/h']);
txt2 = join(['Power Input Required @ ~',num2str(vel(1)),' km/h']);
txt3 = join(['Shaft Power @ ',num2str(V_matched_pr_min),' Volts']);
txt4 = join(['Shaft Power @ ',num2str(V_matched_tr_min),' Volts']);
legend(txt1,txt2,txt3,txt4);
%
txt = join(['[',num2str(rpm_needed_tr_min),',',num2str(Preq_tr_min),']']);
text(rpm_needed_tr_min,Preq_tr_min,txt);
%
txt = join(['[',num2str(rpm_needed_pr_min),',',num2str(Preq_pr_min),']']);
text(rpm_needed_pr_min,Preq_pr_min,txt);


end



function[i_level,i_tr_min,i_pr_min] = determineCurrent(...
    V_matched_cr,V_matched_tr_min,V_matched_pr_min,...
    v_index_cr,v_index_tr_min,v_index_pr_min,...
    rpm_needed,rpm_needed_tr_min,rpm_needed_pr_min,...
    current_matched_volt,rpm_matched_volt)
% current requirements

i_level = interp1(rpm_matched_volt(:,v_index_cr),current_matched_volt(:,v_index_cr),rpm_needed,'linear');

figure()
plot(rpm_matched_volt(:,v_index_cr),current_matched_volt(:,v_index_cr)); %matched index
grid on;
xlim([rpm_needed-1000 rpm_needed+1000]);
ylim([0 i_level+10]);
xlabel('RPM');
ylabel('CURRENT [amps]');
    % cruise
x = [0 rpm_needed rpm_needed rpm_needed]; %manually done
y = [i_level i_level 0 0];
line(x,y,'Color','red','LineStyle','--')
set(get(get(line,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
txt1 = join(['Current @ ~',num2str(V_matched_cr),' Volts']);
legend(txt1);
txt = join(['[',num2str(rpm_needed),',',num2str(i_level),']']);
text(rpm_needed,i_level,txt);


% 

i_tr_min = interp1(rpm_matched_volt(:,v_index_tr_min),current_matched_volt(:,v_index_tr_min),rpm_needed_tr_min,'linear');
i_pr_min = interp1(rpm_matched_volt(:,v_index_pr_min),current_matched_volt(:,v_index_pr_min),rpm_needed_pr_min,'linear');

figure()
plot(rpm_matched_volt(:,v_index_pr_min),current_matched_volt(:,v_index_pr_min),... %matched index
    rpm_matched_volt(:,v_index_tr_min),current_matched_volt(:,v_index_tr_min)) %matched index
grid on;
xlim([max(rpm_needed_tr_min,rpm_needed_pr_min)-1000 max(rpm_needed_tr_min,rpm_needed_pr_min)+1000]);
ylim([0 max(i_tr_min,i_pr_min)+10]);
xlabel('RPM');
ylabel('CURRENT [amps]');
    % pwr min
x = [0 rpm_needed_pr_min rpm_needed_pr_min rpm_needed_pr_min]; %manually done
y = [i_pr_min i_pr_min 0 0];
line(x,y,'Color','red','LineStyle','--')    
    % min thrust
x = [0 rpm_needed_tr_min rpm_needed_tr_min rpm_needed_tr_min]; %manually done
y = [i_tr_min i_tr_min 0 0];
line(x,y,'Color','red','LineStyle','--')    
set(get(get(line,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
txt3 = join(['Current @ ',num2str(V_matched_pr_min),' Volts']);
txt4 = join(['Current @ ',num2str(V_matched_tr_min),' Volts']);
legend(txt3,txt4);
%
txt = join(['[',num2str(rpm_needed_tr_min),',',num2str(i_pr_min),']']);
text(rpm_needed_tr_min,i_pr_min,txt);
%
txt = join(['[',num2str(rpm_needed_pr_min),',',num2str(i_tr_min),']']);
text(rpm_needed_pr_min,i_tr_min,txt);


end
