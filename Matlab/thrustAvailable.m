function[T_avail,P_avail,Preq] = thrustAvailable(V,Pe,Pwr,Torque,Thrust,V_target,...
    Kv_rpm,i0,R,...
    V_matched_cr)

[vel_avg_cr,...
        thrust_cr,...
        power_cr,...
        eff_cr,...
        Q_p_cr,...
        rpm_cr] = extractPropDataAtSpeed(V,Pe,Pwr,Torque,Thrust,V_target);
    
[rpm_matched_volt,current_matched_volt,Qm_matched_volt,...
    eff_m_matched_volt,P_shaft_matched_volt] = estimateMotorPerf(Kv_rpm,i0,R);  

[rpm_needed] = torqueMatchPropMotorAtRpm(V_matched_cr,...
        rpm_cr,Q_p_cr,...
        Qm_matched_volt);
    
[T_avail] = matchThrustAndRpm(rpm_needed,...
        rpm_cr,thrust_cr);
    
    

end

function[vel_avg_cr,...
        thrust_cr,...
        power_cr,...
        eff_cr,...
        Q_p_cr,...
        rpm_cr] = extractPropDataAtSpeed(V,Pe,Pwr,Torque,Thrust,V_target)


hit = 0;
k = 0;

j_max = length(V(1,:));

for j=1:1:j_max
    for i=1:1:30
        if ( abs(V_target - V(i,j)) < 4.5 && hit ~= 1) % +- 3 km/h tolerance
            switch j
                case 1
                    k = 1;
                    p_rpm(:,k) = 1000;
                case 2
                    k = 10;
                    p_rpm(:,k) = 10000;
                case 3
                    k = 11;
                    p_rpm(:,k) = 11000;
                case 4
                    k = 12;
                    p_rpm(:,k) = 12000;
                case 5
                    k = 2;
                    p_rpm(:,k) = 2000;
                case 6
                    k = 3;
                    p_rpm(:,k) = 3000;
                case 7
                    k = 4;
                    p_rpm(:,k) = 4000;
                case 8
                    k = 5;
                    p_rpm(:,k) = 5000;
                case 9
                    k = 6;
                    p_rpm(:,k) = 6000;
                case 10
                    k = 7;
                    p_rpm(:,k) = 7000;
                case 11
                    k = 8;
                    p_rpm(:,k) = 8000;
                case 12
                    k = 9;
                    p_rpm(:,k) = 9000;                
            end
            
            Q_p(:,k) = Torque(i,j);
            eff_p(:,k) = Pe(i,j);
            thrust_p(:,k) = Thrust(i,j);
            power_in(:,k) = Pwr(i,j);
            vel(:,k) = V(i,j);
  
            hit = 1;
        end
    end
    hit = 0;
    
end

% Correcting index
    % torque
Q_p_cr = nonzeros(Q_p(1,:));
    % rpm
rpm_cr = nonzeros(p_rpm(1,:));
    % eff
eff_cr = nonzeros(eff_p(1,:));
    % thrust
thrust_cr = nonzeros(thrust_p(1,:));
    % power
power_cr = nonzeros(power_in(1,:));
    % avg speed of iterated data
vel_avg_cr = mean(nonzeros((vel(1,:))));

%outputs

end

function[rpm_matched_volt,current_matched_volt,Qm_matched_volt,...
    eff_m_matched_volt,P_shaft_matched_volt] = estimateMotorPerf(Kv_rpm,i0,R)

% Iterating optimal operating voltage for motor during cruise
Kv_rad = Kv_rpm*2*pi/60; %rad/s/V
i = 1;
for Volt=0:0.05:37
for rad=1:1:1300
rpm_matched_volt(rad,i) = rad*60/(2*pi);
current_matched_volt(rad,i) = (Volt - rad/Kv_rad)*(1/R);
Qm_matched_volt(rad,i) = ((Volt - rad/Kv_rad )*(1/R) - i0)*(1/Kv_rad);
eff_m_matched_volt(rad,i) = (1 - ((i0*R)/(Volt - rad/Kv_rad)))*(rad/(Volt*Kv_rad));
P_shaft_matched_volt(rad,i) = ((Volt - rad/Kv_rad)*(1/R) - i0)*(rad/Kv_rad);
end
i = i + 1;
end

end

function[rpm_needed] = torqueMatchPropMotorAtRpm(V_matched_cr,...
        rpm_cr,Q_p_cr,...
        Qm_matched_volt)
      
v_index_cr = round(V_matched_cr/0.05);
for rpm=100:1:12000
Q_p = interp1(rpm_cr,Q_p_cr,rpm,'linear');
Q_m = Qm_matched_volt(round(rpm*2*pi/60),v_index_cr);
if ( abs(Q_p - Q_m) < 1)
    rpm_needed = rpm;
end

end

end


function[T_avail] = matchThrustAndRpm(rpm_needed,...
        rpm_cr,thrust_cr)
   
T_avail = interp1(rpm_cr,thrust_cr,rpm_needed,'linear');

end

    


