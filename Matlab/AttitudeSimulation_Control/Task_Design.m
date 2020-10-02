% Task_Design: Definition of a task for a controller to execute.

function Task = Task_Design(initial_state,initial_statedot)
Task = struct;

Task.dt             = 0.025;       % sampling time period

Task.start_time     = 0;

Task.goal_time      = 5;           % Time to reach goal
% FOR ILQC goal_time needs to be 5 due to dimensioning.

% (ER/Gibbs parameter)                    
Task.goal_x         = [0; 0; 0;    % position (DESIRED ATTITUDE)
                        0; 0; 0.0 ]; % angular rates (DESIRED OMEGA)
% (either set DESIRED ATTITUDE or DESIRED OMEGA, if DESIRED OMEGA is chosen,
% set position = [0; 0; 0];                    
                                    
Task.max_iteration  = 15;           % Maximum ILQC iterations

switch initial_state
    case 'random'
        Task.p0 =rand(3,1);
    case 'man'
        p01 = 1;
        p02 = 1;
        p03 = 1;
        Task.p0 = [p01;p02;p03];
    case 'inertial'
        Task.p0 = [0;0;0];
end

switch initial_statedot
    case 'zero'
        w10 = 0.0; %rad/s
        w20 = 0.0;
        w30 = 0.0;
        Task.w0 = [w10;w20;w30]; %rad/s
    case 'random'
        Task.w0 = rand(3,1) / 100;        
    case 'man'
        w10 = 0.0; %rad/s
        w20 = 0.0;
        w30 = 0.0;
        Task.w0 = [w10;w20;w30]; %rad/s
end


Task.cost = [];                    % cost encodes performance criteria of 
                                   % how to execute the task. Filled later.
end

