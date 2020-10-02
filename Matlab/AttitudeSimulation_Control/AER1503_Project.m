%%
% AER1503H Spacecraft Dynamics and Control II Project
% Spacecraft Attitude Control System using optimal control and
% Euler-Rodrigues (ER) attitude parameterization
%
% 04-13-2020 - Mahal M

clear
clc
%%
% Following parameters can be changed :
%
% 'initial_statedot' -> can be set to -> random or man or zero
% 'initial_state' -> can be set to -> random or man or inertial
%
% 'controller_type' -> can be set to -> PI or Optimal or Error
% 'optimal_controller_type' -> can be set to -> inertial or error or tracking

% Initial Euler-Rodrigues parameter
initial_state = 'man'; %random or man or inertial
% Initial angular velocity
initial_statedot = 'zero'; %random or man or zero

% Moment of Inertia matrix
% may be modified
i1 = 0.1;
i2 = 0.1;
i3 = 0.1;
%
I = [i1 0 0;
    0 i2 0;
    0 0 i3];

% TASK
Task = Task_Design(initial_state,initial_statedot);
% COST DESIGN
Task.cost = Cost_Design(Task);

% Simulation time constants
dt = Task.dt; %s
n = Task.goal_time; %s

% Initial conditions
    % may be modified
% Inertial reference frame
Fi = eye(3);
% Body reference frame
Fb = eye(3);

th0 = [0;0;0];  %rad
dth0 = Task.w0;      %rad/s
    
% Initialization 
p = Task.p0; %Euler-Rogridues parametrization (ER)
[th01,th02,th03] = rod2angle(p'); % converting from ER to Euler Angles (EA)
th = [th01;th02;th03]; %initial EA
dth = dth0;

% Desired trajectory
    % Desired ER parameters
p_d = Task.goal_x(1:3); % DESIRED ATTITUDE
dp_d = Task.goal_x(4:6);% DESIRED OMEGA
% (either set DESIRED ATTITUDE or DESIRED OMEGA, if DESIRED OMEGA is chosen,
% set position = [0;0;0] in Task

[thd1, thd2, thd3] = rod2angle(p_d');   %converting to desired EA
th_d = [thd1;thd2;thd3];

[dthd1, dthd2, dthd3] = rod2angle(dp_d'); %converting to desired EA
dth_d = [dthd1;dthd2;dthd3];

% Control Input
controller_type = 'Optimal' ; % PI or Optimal or Error or ILQC
optimal_controller_type = 'tracking' ; % inertial or error or tracking

% Distrubance Input
    % disturbances are not incorportated into the control scheme but will 
    % affect the simulation 
disturbance_type = 'none'; %linear or none

% Attitude Simulation Calculations
[Controller,Cost] = AttitudeSimulation(Task,controller_type,optimal_controller_type,disturbance_type,...
    p,th,dth,p_d,dp_d,I,Fi);

% Assigning controller values
theta = Controller.theta;
F = Controller.F;
p_sim = Controller.p_sim;
u_input = Controller.u_input;
u_disturb = Controller.u_disturb;
error_p = Controller.error_p;
error_dp = Controller.error_dp;
t = Controller.t;

% Fixed inertial frame used for plotting
% needs to be modified if Fi is modified
Fi_plot = [0 0 0;1 0 0;0 0 0;0 1 0;0 0 0;0 0 1];
% Bounds of plot
xmin = -1;ymin = -1;zmin= -1;
xmax = 1;ymax = 1;zmax = 1;
% Axis type used during simulation
axis_type = 'man'; % man or auto

% Simulation
for j=1:1:size(t,1)
    pl = plot3(Fi_plot(:,1),Fi_plot(:,2),Fi_plot(:,3),'--',...
        F(:,1,j),F(:,2,j),F(:,3,j));
    pl(1).LineWidth = 2;
    pl(2).LineWidth = 2;   
    grid on;
    title('Attitude Control System Simulation');
    switch axis_type
        case 'man'
            axis([xmin xmax ymin ymax zmin zmax]);
        case 'auto'
            axis square;
    end  
    pause(0.0001);
end

% Plot of theta evolution over time
theta_plot ='';

switch theta_plot

    case 'wrapped'
        figure(2)
        plot(t,theta,...
            t,thWrapped)
        legend('\Theta_1','\Theta_2','\Theta_3',...
            '\Theta_1 wrapped','\Theta_2 wrapped','\Theta_3 wrapped');
        grid on;
        xlabel('Time [s]');
        ylabel('Angle [rad]');
    case ''
        figure(2)
        title('B-Frame Euler Angles Evolution');
        yyaxis left
        plot(t,theta)
        ylabel('Angle [rad]');
        xlabel('Time [s]');
        grid on;

        yyaxis right
        plot(t,rad2deg(theta))
        legend('\Theta_1','\Theta_2','\Theta_3',...
            '\Theta_1','\Theta_2','\Theta_3');
        ylabel('Angle [degrees]');
end

% Error plots
    % ER parameter
figure(3);
plot(t,error_p,t,error_dp);
name = legend('$p_{1}$ error','$p_{2}$ error','$p_{3}$ error',...
    '$\dot{p}_{1}$ error','$\dot{p}_{2}$ error','$\dot{p}_{3}$ error');
set(name,'Interpreter','latex');
grid on;
xlabel('Time [s]');
ylabel('Angle [rad] , Speed [rad/s]');
title('Error of ER/Gibbs parameters')

% Control Input Plot
if strcmp(controller_type,'ILQC')
t = t(1:size(t,1)-1);
  figure(5);
plot(t,u_input,...
    t,u_disturb);
legend('u_1','u_2','u_3',...
    'd_1','d_2','d_3');
grid on;
xlabel('Time [s]');
ylabel('Input torque [Nm]');
title('Control Input'); 
else
  figure(5);
plot(t,u_input,...
    t,u_disturb);
legend('u_1','u_2','u_3',...
    'd_1','d_2','d_3');
grid on;
xlabel('Time [s]');
ylabel('Input torque [Nm]');
title('Control Input');  
    
end
% Cost
fprintf('Final trajectory cost is %6.4f ' , Cost)
