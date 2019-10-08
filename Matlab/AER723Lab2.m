%% Open Loop Torque Control 
load('TRQRAMPDATA_2017-10-23_12.29.33.mat');
load('OL_alldata.mat');
time=speedVoltage005(1,:);
Commanded_torque=speedVoltage005(16,:);
figure(1);
plot(time,Commanded_torque*0.01);
hold on;
grid on;
Torq_measured=speedVoltage005(14,:);
Torq_estimate=speedVoltage005(8,:);
Torq_estimate_current=speedVoltage005(11,:);
plot(time,Torq_measured,time,Torq_estimate,time,Torq_estimate_current);
legend('Commanded Torque','Measured Torque','Estimated Torque from M=J*thetadoubledot','Estimated Torque from current');
xlabel('Time [s]');
ylabel('Torque [Nm]');
title('Open Loop Torque vs Time');
axis([0 35 -0.012 0.015]);

% M_ss -> steady state torque 
M_ss_1=mean(Torq_measured(1801:2201)); %steady between 9-11 secs
dE_dt_1=(M_ss_1/J)/speedTF_DCgain;

data02V=load('OL_alldata_0_2V.mat');
Torq_measured_2=data02V.speedVoltage005(14,:);

M_ss_2=mean(Torq_measured_2(1801:2201)); %steady between 9-11 secs
dE_dt_2=(M_ss_2/J)/speedTF_DCgain;

data2V=load('OL_alldata_2V.mat');
Torq_measured_3=data2V.speedVoltage005(14,:);

M_ss_3=mean(Torq_measured_3(801:1001)); %steady between 4-5 secs
dE_dt_3=(M_ss_3/J)/speedTF_DCgain;

figure(2);
hold on;
grid on;
plot(time,Torq_measured_2,time,Torq_measured_3);
title('Ramp test 2/3');
legend('Ramp test 2','Ramp test 3');

dE_dt=[dE_dt_1;dE_dt_2;dE_dt_3];
M_ss=[M_ss_1;M_ss_2;M_ss_3];

figure(3);
hold on;
grid on;
plot(dE_dt,M_ss,'-x');
title('Steady State Torque vs dE/dt');
xlabel('dE/dt [V/s]');
ylabel('M_s_s [Nm]');




