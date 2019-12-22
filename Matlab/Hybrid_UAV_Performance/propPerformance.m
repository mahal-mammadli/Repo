function[V,J,Pe,Ct,Cp,Pwr,Torque,Thrust] = propPerformance(str1,str2,directory)

imax = length(str1);

for i=1:1:imax
% Importing data
filename = insertAfter(directory,str2,str1(i,1));
dataStructure = importdata(filename);
prop_data = dataStructure.data;

%Sorting data
V(:,i) = prop_data(:,1) * 1.60934; %convert mph to kmph
J(:,i) = prop_data(:,2);
Pe(:,i) = prop_data(:,3);
Ct(:,i) = prop_data(:,4);
Cp(:,i) = prop_data(:,5);
Pwr(:,i) = prop_data(:,6) * 745.7; % convert hp to Watts
Torque(:,i) = prop_data(:,7) * 0.11; %convert in-lbf to Nm
Thrust(:,i) = prop_data(:,8) * 4.44822; %convert lbf to N

end

% Thrust
figure()
plot(V,Thrust)
grid on
xlabel('Speed [km/h]');
ylabel('Thrust [N]');
legend({'1000 rpm','10000 rpm','11000 rpm', ...
    '12000 rpm','2000 rpm','3000 rpm','4000 rpm',...
    '5000 rpm','6000 rpm','7000 rpm','8000 rpm','9000 rpm'},...
    'FontSize',5.5);

% Torque
figure()
plot(V,Torque)
grid on
xlabel('Speed [km/h]');
ylabel('Torque [Nm]');
legend({'1000 rpm','10000 rpm','11000 rpm', ...
    '12000 rpm','2000 rpm','3000 rpm','4000 rpm',...
    '5000 rpm','6000 rpm','7000 rpm','8000 rpm','9000 rpm'},...
    'FontSize',5.5);

% Input power
figure()
plot(V,Pwr)
grid on
xlabel('Speed [km/h]');
ylabel('Power [W]');
legend({'1000 rpm','10000 rpm','11000 rpm', ...
    '12000 rpm','2000 rpm','3000 rpm','4000 rpm',...
    '5000 rpm','6000 rpm','7000 rpm','8000 rpm','9000 rpm'},...
    'FontSize',5.5);

% Efficiency
figure()
plot(V,Pe)
grid on
xlabel('Speed [km/h]');
ylabel('Efficiency');
legend({'1000 rpm','10000 rpm','11000 rpm', ...
    '12000 rpm','2000 rpm','3000 rpm','4000 rpm',...
    '5000 rpm','6000 rpm','7000 rpm','8000 rpm','9000 rpm'},...
    'FontSize',5.5);
