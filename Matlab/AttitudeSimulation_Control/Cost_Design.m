% Cost_Design: Definition of cost functions for reaching goal state

function Cost = Cost_Design(Task)
%COST_DESIGN Creates a cost function for LQR and for ILQC
%   .Q_lqr 
%   .R_lqr
%
%   A ILQC cost J = h(x) + sum(l(x,u)) is defined by:
%   .h   - continuous-time terminal cost
%   .l - continous-time intermediate cost

% Spacecraft system state (ER/Gibbs parameter) p
syms p1 p2 p3 dth1 dth2 dth3 real
x_sym = [p1 p2 p3 ...       % attitude position p 
          dth1 dth2 dth3]';      % angular velocity dth   
      
% Spacecraft control input u (Torques)
syms Mx My Mz real; u_sym = [Mx My Mz]';

% Time variable for time-varying cost
syms t_sym real;
Cost = struct;


%% LQR cost function
% LQR controller
% Q needs to be symmetric and positive semi-definite
Q = diag([5 5 5 ...         % penalize orientations
            1 1 1]);        % penalize angular velocities
        
Cost.Q_lqr = Q;          
% R needs to be positive definite
R = diag([1 1 1]);          % penalize control inputs
Cost.R_lqr = R;        

%% ILQC cost function
Cost.Qm  = Cost.Q_lqr;                  % it makes sense to redefine these
Cost.Rm  = Cost.R_lqr;
Cost.Qmf = Cost.Q_lqr;

% Reference states and input the controller is supposed to track
Cost.u_eq = zeros(3,1);
Cost.x_eq = Task.goal_x;

% alias for easier referencing
x = x_sym; 
u = u_sym;
x_goal = Task.goal_x;


Cost.h = simplify((x-x_goal)'*Cost.Qmf*(x-x_goal));
Cost.l = simplify( (x-Cost.x_eq)'*Cost.Qm*(x-Cost.x_eq) ...
             + (u-Cost.u_eq)'*Cost.Rm*(u-Cost.u_eq));
               
Cost.x  = x;
Cost.u  = u;
Cost.t  = t_sym; 
end
