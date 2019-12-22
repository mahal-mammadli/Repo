function[rpm,current,Qm,P_shaft,P_elec,eff_m] = electriMotorPerformance(Kv_rpm,...
    i0,R,Volt_max)

Kv_rad = Kv_rpm*2*pi/60; %rad/s/V
i = 1;
for Volt=5:1:Volt_max
for rad=1:1:1000
    
rpm(rad,i) = rad*60/(2*pi);
current(rad,i) = (Volt - rad/Kv_rad)*(1/R);
Qm(rad,i) = ((Volt - rad/Kv_rad )*(1/R) - i0)*(1/Kv_rad);
P_shaft(rad,i) = ((Volt - rad/Kv_rad)*(1/R) - i0)*(rad/Kv_rad);
P_elec(rad,i) = Volt*current(rad,i);
eff_m(rad,i) = (1 - ((i0*R)/(Volt - rad/Kv_rad)))*(rad/(Volt*Kv_rad));
if (eff_m(rad,i) > 1)
    eff_m(rad,i) = NaN;
end

end
txt{i} = join([num2str(Volt),' V']);
i = i + 1;

end

figure()
plot(rpm,current)
ylim([0,max(current(1,:))]);
xlabel('Motor Speed [rpm]');
ylabel('Current [amps]');
legend(txt,...
    'FontSize',6);

figure()
plot(rpm,Qm)
ylim([0,max(Qm(1,:))]);
xlabel('Motor Speed [rpm]');
ylabel('Motor Torque [Nm]');
legend(txt,...
    'FontSize',6);

figure()
plot(rpm,P_shaft)
ylim([0,max(max(P_shaft))]);
xlabel('Motor Speed [rpm]');
ylabel('Shaft Power [W]');
legend(txt,...
    'FontSize',6);

figure()
plot(rpm,eff_m)
ylim([0,1]);
xlabel('Motor Speed [rpm]');
ylabel('Efficiency');
legend(txt,...
    'FontSize',6);


    