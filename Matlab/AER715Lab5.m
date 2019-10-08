%--------------------------------------
% AER 715 Introduction to Avionics and Systems  
% Lab 5 – “Control System Testing and Analysis”
% Mahal Mammadli 500642220
% Wenjing Liang 500625868
%---------------------------------------------
%% Introduction 

%   In the previous two labs a mathematical model for the elevation 
% dynamics of the 3 degrees of freedom helicopter was constructed using 
% both analytical and experimental techniques. Moreover, the students also 
% developed a control system using the root locus technique to achieve a 
% desired level of performance with a percentage overshoot lower than 25
% and a damping period no longer than 12 seconds. In this experiment, the 
% team has done the performance test using the controllers designed in the 
% previous lab. After doing the test and analyzing the data, the team has 
% compared the experimental results to its designed controllers. In 
% addition, the team will also compare the performance of the controllers 
% with a stock controller. The evaluation of helicopter’s performance is 
% based on the analysis that are completed in Matlab. The team has done 
% three sets of testing using various controller gains (Kp,Ki,Kd), which
% are referred to the transfer functions. Each set has done three trials
% to ensure the accuracy of the experimental data.

%% Post Lab Exercises 
%% Question 1
time_stock=stockData.time(1:1934);
time1=elevData1.time(1:1933);
time2=elevData2.time(1:1928);
time3=elevData3.time(1:1935);
Elev_stock=stockData.signals.values((1:1934),2);
Elev1=elevData1.signals.values((1:1933),2);
Elev2=elevData2.signals.values((1:1928),2);
Elev3=elevData3.signals.values((1:1935),2);

time_t1=travData1.time(2433:3933);
time_t2=travData2.time(2428:3928);
time_t3=travData3.time(2435:3935);

Trav1=travData1.signals.values((2433:3933),2);
Trav2=travData2.signals.values((2428:3928),2);
Trav3=travData3.signals.values((2435:3935),2);

Gains_Elev_Data1=[4.1419;0.49455;10.057];
Gains_Elev_Data2=[64.261;35.492;177.4];
Gains_Elev_Data3=[58.971;34.582;152.59];
Gains_Trav_Data1=[29.176;1;150];
Gains_Trav_Data2=[18.667;1;125];
Gains_Trav_Data3=[29.176;1;150];

Row={'Kp';'Ki';'Kd'};
T = table(Gains_Elev_Data1,Gains_Elev_Data2,Gains_Elev_Data3,'RowNames',Row)
T2 =table(Gains_Trav_Data1,Gains_Trav_Data2,Gains_Trav_Data3,'RowNames',Row)

figure(1);
grid on;
hold on;
plot(time_stock,Elev_stock,'--',time1,Elev1,'-',time2,Elev2,'-',time3,Elev3,':');
title('Elevation versus time');
xlabel('Time [s]');
ylabel('Elevation [cm]');
legend('Stock Data','Elev Data 1','Elev Data 2','Elev Data 3');

% Comparing the four controllers, the two best responses are seen from Elev
% Data 2 and Elev Data 3. Their elevation response is smooth with a small
% percent overshoot compared to the stock data. The compensator in Elev 
% Data 1 was not able to even get the heli off the ground. The next best 
% performance was done by the stock data compensator. It was the highest 
% overshoot compared to the rest and was more osicallatory in its settling.
% The second order and third order model compensator designs had the best
% percent overshoot and settling time compared to the first order model and
% stock data. 

figure(2);
grid on;
hold on;
plot(time_t1,Trav1,'--',time_t2,Trav2,':',time_t3,Trav3,'-');
title('Traverse versus time');
xlabel('Time [s]');
ylabel('Traverse [deg]');
legend('Trav Data 1','Trav Data 2','Trav Data 3');

% From the traverse controllers the best perfromance was from Trav Data 2.
% It reaches 90 degrees the quickest and minimal overshoot. The other two
% either overshoot too much or undershot in 25 - 40 second time frame. 

%% Question 2
time_stock_volts=stockVolts.time;
time_volts1=elevVolts1.time;
time_volts2=elevVolts2.time;
time_volts3=elevVolts3.time; 

Kp_s=stockVolts.signals.values(:,1);
Ki_s=stockVolts.signals.values(:,2);
Kd_s=stockVolts.signals.values(:,3);
Sum_s=stockVolts.signals.values(:,4);

Kp_1=elevVolts1.signals.values(:,1);
Ki_1=elevVolts1.signals.values(:,2);
Kd_1=elevVolts1.signals.values(:,3);
Sum_1=elevVolts1.signals.values(:,4);

Kp_2=elevVolts2.signals.values(:,1);
Ki_2=elevVolts2.signals.values(:,2);
Kd_2=elevVolts2.signals.values(:,3);
Sum_2=elevVolts2.signals.values(:,4);

Kp_3=elevVolts3.signals.values(:,1);
Ki_3=elevVolts3.signals.values(:,2);
Kd_3=elevVolts3.signals.values(:,3);
Sum_3=elevVolts3.signals.values(:,4);


time_tvolts1=travVolts1.time;
time_tvolts2=travVolts2.time;
time_tvolts3=travVolts3.time;

Kp_t1=travVolts1.signals.values(:,1);
Ki_t1=travVolts1.signals.values(:,2);
Kd_t1=travVolts1.signals.values(:,3);
Sum_t1=travVolts1.signals.values(:,4);

Kp_t2=travVolts2.signals.values(:,1);
Ki_t2=travVolts2.signals.values(:,2);
Kd_t2=travVolts2.signals.values(:,3);
Sum_t2=travVolts2.signals.values(:,4);

Kp_t3=travVolts3.signals.values(:,1);
Ki_t3=travVolts3.signals.values(:,2);
Kd_t3=travVolts3.signals.values(:,3);
Sum_t3=travVolts3.signals.values(:,4);

figure(3);
grid on;
hold on;
plot(time_stock_volts,Kp_s,'--',time_stock_volts,Ki_s,':',time_stock_volts,Kd_s,...
    '-',time_stock_volts,Sum_s,'-.');
title('Gains versus time Stock Data');
xlabel('Time [s]');
ylabel('Voltage Gains');
legend('Kp','Ki','Kd','Sum');

figure(4);
grid on;
hold on;
plot(time_volts1,Kp_1,'--',time_volts1,Ki_1,':',time_volts1,Kd_1,'-',time_volts1,Sum_1,'-.');
title('Gains versus time Elev Data1');
xlabel('Time [s]');
ylabel('Voltage Gains');
legend('Kp','Ki','Kd','Sum');

figure(5);
grid on;
hold on;
plot(time_volts2,Kp_2,'--',time_volts2,Ki_2,':',time_volts2,Kd_2,'-',time_volts2,Sum_2,'-.');
title('Gains versus time Elev Data2');
xlabel('Time [s]');
ylabel('Voltage Gains');
legend('Kp','Ki','Kd','Sum');

figure(6);
grid on;
hold on;
plot(time_volts3,Kp_3,'--',time_volts3,Ki_3,':',time_volts3,Kd_3,'-',time_volts3,Sum_3,'-.');
title('Gains versus time Elev Data3');
xlabel('Time [s]');
ylabel('Voltage Gains');
legend('Kp','Ki','Kd','Sum');

figure(7)
grid on;
hold on;
plot(time_tvolts1,Kp_t1,'--',time_tvolts1,Ki_t1,':',time_tvolts1,Kd_t1,'-',time_tvolts1,Sum_t1,'-.');
title('Gains versus time Trav Data1');
xlabel('Time [s]');
ylabel('Voltage Gains');
legend('Kp','Ki','Kd','Sum');
xlim([25 40]);

figure(8)
grid on;
hold on;
plot(time_tvolts2,Kp_t2,'--',time_tvolts2,Ki_t2,':',time_tvolts2,Kd_t2,'-',time_tvolts2,Sum_t2,'-.');
title('Gains versus time Trav Data2');
xlabel('Time [s]');
ylabel('Voltage Gains');
legend('Kp','Ki','Kd','Sum');
xlim([25 40]);

figure(9)
grid on;
hold on;
plot(time_tvolts3,Kp_t3,'--',time_tvolts3,Ki_t3,':',time_tvolts3,Kd_t3,'-',time_tvolts3,Sum_t3,'-.');
title('Gains versus time Trav Data3');
xlabel('Time [s]');
ylabel('Voltage Gains');
legend('Kp','Ki','Kd','Sum');
xlim([25 40]);

% The gains for the first order system (Elev Data1) were really small which
% can explain  the fact that the heli was unable to lift off the ground. 
% Not enough power was supplied to the motor. Observing Elev Data2 and Elev
% Data3 the gain values are very high in the begining and then keep a constant low
% value to maintain steady level flight. The stock gains were relatively
% low compared to Elev Data2/3 but oscillated more. 

% The gains for the traverse controllers are relatively similar. Trav Data1
% having a bit more voltage gain than the other two sets of data. 

%
%% Conclusion 
%    By doing this lab, the team has tested the controller. The first set 
% with relatively low voltages did not let the helicopter go up and 
% balanced at curtain position. However, the second and third ones worked.
% In comparison with the sample input K values, the results of percentage 
% overshoot is higher but the damping time is relatively similar. To 
% improve the performance of the helicopter controller, the team has to 
% try more root locus diagrams and find K values that are reducing the 
% percentage overshoot. Nevertheless, the damping time should not be
% setting too short (<10s).