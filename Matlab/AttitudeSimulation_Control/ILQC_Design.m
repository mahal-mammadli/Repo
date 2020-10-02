% ILQC_Design: Implementation of the ILQC controller.

function [Controller] = ILQC_Design(Task,controller_lqr,p,th,dth,p_d,dp_d,I,Fi)
% ILQC_DESIGN Implements the Iterative Linear Quadratic Controller (ILQC)

% Define functions that return the quadratic approximations of the cost 
% function at specific states and inputs
% Example usage:
%     xn = [ x y z ... ]'; 
%     un = [ Mx My Mz]';
%     t  = t;
%     Qm(xn,un) = Qm_fun(t,xn,un); 

% stage cost (l) quadratizations
l_ = Task.cost.l*Task.dt;
q_fun   = matlabFunction(  l_,'vars',{Task.cost.t,Task.cost.x,Task.cost.u});
% dl/dx
l_x = jacobian(Task.cost.l,Task.cost.x)'*Task.dt; % cont -> discr. time
Qv_fun  = matlabFunction( l_x,'vars',{Task.cost.t,Task.cost.x,Task.cost.u});
% ddl/dxdx
l_xx = jacobian(l_x,Task.cost.x);
Qm_fun  = matlabFunction(l_xx,'vars',{Task.cost.t,Task.cost.x,Task.cost.u});
% dl/du
l_u = jacobian(Task.cost.l,Task.cost.u)'*Task.dt; % cont -> discr. time
Rv_fun  = matlabFunction( l_u,'vars',{Task.cost.t,Task.cost.x,Task.cost.u});
% ddl/dudu
l_uu = jacobian(l_u,Task.cost.u);
Rm_fun  = matlabFunction(l_uu,'vars',{Task.cost.t,Task.cost.x,Task.cost.u});
% ddl/dudx
l_xu = jacobian(l_x,Task.cost.u)';
Pm_fun  = matlabFunction(l_xu,'vars',{Task.cost.t,Task.cost.x,Task.cost.u});

% terminal cost (h) quadratizations
h_ = Task.cost.h;
qf_fun  = matlabFunction(  h_,'vars',{Task.cost.x});
% dh/dx
h_x = jacobian(Task.cost.h,Task.cost.x)';
Qvf_fun = matlabFunction( h_x,'vars',{Task.cost.x});
% ddh/dxdx
h_xx = jacobian(h_x,Task.cost.x);
Qmf_fun = matlabFunction(h_xx,'vars',{Task.cost.x});

% dimensions
n = length(Task.cost.x); % dimension of state space
m = length(Task.cost.u); % dimension of control input
N  = (Task.goal_time-Task.start_time)/Task.dt + 1; % number of time steps

% desired value function V* is of the form Eqn.(9) in handout
% V*(dx,n) = s + dx'*Sv + 1/2*dx'*Sm*dx
s    = zeros(1,N);
Sv   = zeros(n,N);
Sm   = zeros(n,n,N);

% Initializations
%theta_temp = init_theta();
duff = zeros(m,1,N-1);
%K    = repmat(theta_temp(2:end,:)', 1, 1, N-1);
K = zeros(m,n,N-1);
sim_out.t = zeros(1, N);
sim_out.x = zeros(n, N);
sim_out.u = zeros(m, N-1);
X0 = zeros(n, N);
U0 = zeros(m, N-1);

% % Shortcuts for function pointers to linearize systems dynamics:
% % e.g. Model_Alin(x,u,Model_Param)
% Model_Param = Model.param.syspar_vec;
% Model_Alin  = Model.Alin{1}; 
% Model_Blin  = Model.Blin{1}; 

% Implementation of ILQC controller
% Each ILQC iteration approximates the cost function as quadratic around the
% current states and inputs and solves the problem using DP.
i  = 1;
while ( i <= Task.max_iteration && ( norm(squeeze(duff)) > 0.01 || i == 1 ))
     
    %% Forward pass / "rollout" of the current policy
    % =====================================================================
    % [Todo] rollout states and inputs
    if i > 1
        uc = @(dth,p,error_p,error_dp,i) Controller.u_fb(:,:,i)*[p; dth];
        ud = @(th) 0;
        u = @(th,dth,p,error_p,error_dp,i) uc(dth,p,error_p,error_dp,i) + ud(th);
        ddth = @(th,dth,u,p,error_p,error_dp,i) inv(I)*(u(th,dth,p,error_p,error_dp,i)- skew(dth)*I*dth);
        dp = @(dth,p) 0.5*(eye(3) + p*p' + skew(p))*dth;
        er_p = @(p) p - p_d;
        er_dp = @(dp) dp - dp_d;
        % Loop completes the 4th order Runge Kutta integral
        j = 1;
        C = eye(3);
        dt = Task.dt;
        n = Task.goal_time;
        for k = 0:dt:n
            error_p(j,:)  = er_p(p);
            error_dp(j,:)  = er_dp(dp(dth,p));
    
            if (j < 201)
            % Adusting error term, to compensate for desired omegas
            p_d = p_d + dp_d*dt;
            error_p(j,:) = p - p_d;
                    
            k1 = dt*ddth(th,dth,u,p,error_p(j,:),error_dp(j,:),j);
            k2 = dt*ddth(th+k1/2,dth,u,p,error_p(j,:),error_dp(j,:),j);
            k3 = dt*ddth(th+k2/2,dth,u,p,error_p(j,:),error_dp(j,:),j);
            k4 = dt*ddth(th+k3,dth,u,p,error_p(j,:),error_dp(j,:),j);
            
            % Logging Control Input
            u_input(j,:) = u(th,dth,p,error_p(j,:),error_dp(j,:),j);
            u_disturb(j,:) = ud(th);
            end
        dth = dth + (k1 + 2*k2 + 2*k3 + k4)/6;         
        p = p + dp(dth,p)*dt;
        C = ((1 - p'*p)*eye(3) + 2*p*p' - 2*skew(p)) / (1 + p'*p);
        % Rotation
        for l=1:1:3
            Fb(:,l) = C*Fi(:,l);
        end
        F(:,:,j) = [0 0 0;Fb(:,1)';0 0 0;Fb(:,2)';0 0 0;Fb(:,3)'];         
        % Updating EA
        th = th + dth*dt;
        % Logging data for plotting
        p_sim(j,:) = p';
        dth_sim(j,:) = dth;
        dp_sim(j,:) = dp(dth,p)';
        theta(j,:) = th;
        t(j,:) = k;
        
        j = j + 1;
        end
        Controller.theta = theta;
        Controller.F = F;
        Controller.p_sim = p_sim;
        Controller.dp_sim = dp_sim;
        Controller.dth_sim = dth_sim;
        Controller.u_input = u_input;
        Controller.u_disturb = u_disturb;
        Controller.error_p = error_p;
        Controller.error_dp = error_dp;
        Controller.t = t;

        % Modifications for ILQC
        Controller.x = [p_sim dth_sim];
        Controller.u = u_input;
        
        Sim_Out_ILQC = Controller;
    else
    Sim_Out_ILQC = controller_lqr;
    end
    % =====================================================================
    
    % pause if cost diverges
    cost(i) = Calculate_Cost(Sim_Out_ILQC, q_fun, qf_fun);
    fprintf('Cost of Iteration %2d (metric: ILQC cost function!): %6.4f \n', i-1, cost(i));
    
    if ( i > 1 && cost(i) > 2*cost(i-1) )
        fprintf('It looks like the solution may be unstable. \n')
        fprintf('Press ctrl+c to interrupt iLQG, or any other key to continue. \n')
        pause
    end
    
    %% Solve Riccati-like equations backwards in time
	% =====================================================================
    % Define nominal state and control input trajectories (dim by
    % time steps). Note: sim_out contains state x, input u, and time t
    %
    X0 = Sim_Out_ILQC.x; % x_bar
    U0 = Sim_Out_ILQC.u; % u_bar
    T0 = Sim_Out_ILQC.t; % t
    % =====================================================================

    Q_t = Task.cost.Qmf;
    Q_s = Task.cost.Qm;
    R_s = Task.cost.Rm;
    state_goal = Task.goal_x;
    
    % =====================================================================
    % Initialize the value function elements starting at final time
    % step (Problem 1.1 (g))
    %
    xf = X0(:,end); % final state when using current controller
    Sm(:,:,N) = Qmf_fun(xf);
    Sv(:,N) = Qvf_fun(xf);
    s(N) = qf_fun(xf);
    % =====================================================================
    
    % "Backward pass": Calculate the coefficients (s,Sv,Sm) for the value
    % functions at earlier times by proceeding backwards in time
    % (DP-approach)
    for k = (length(sim_out.t)-1):-1:1
        
        % state of system at time step n
        x0 = X0(k,:);
        u0 = U0(k,:);
        
        % =================================================================
        % [Todo] Discretize and linearize continuous system dynamics Alin
        % around specific pair (xO,uO). See exercise sheet Eqn. (18) for
        % details.
        %
        Alin = [0 0 0 0.5 0 0;
            0 0 0 0 0.5 0;
            0 0 0 0 0 0.5;
            0 0 0 0 0 0;
            0 0 0 0 0 0;
            0 0 0 0 0 0];
        
        Blin = [0 0 0;
            0 0 0;
            0 0 0;
            1/I(1,1) 0 0;
            0 1/I(2,2) 0;
            0 0 1/I(3,3)];
        
        A = eye(6) + Alin*Task.dt;
        B = Blin*Task.dt;
        % =================================================================

        % =================================================================
        % [Todo] quadratize cost function
        % [Note] use function {q_fun, Qv_fun, Qm_fun, Rv_fun, Rm_fun,
        % Pm_fun} provided above.
        %
        t0 = T0(k,:);
        % Adjusting x0,u0 for cost functions
        x0 = x0';
        u0 = u0';
        
        q =  q_fun(t0,x0,u0);
        Qv = Qv_fun(t0,x0,u0);
        Qm = Qm_fun(t0,x0,u0);
        Rv = Rv_fun(t0,x0,u0);
        Rm = Rm_fun(t0,x0,u0);
        Pm = Pm_fun(t0,x0,u0);
        % =================================================================

        % =================================================================
        % [Todo] control dependent terms of cost function (Problem 1.1 (f))
        %
        g = Rv + B'*Sv(:,k+1);        % linear control dependent
        G = Pm + B'*Sm(:,:,k+1)*A;	% control and state dependent
        H = Rm + B'*Sm(:,:,k+1)*B;	% quadratic control dependent
        %
        H = (H+H')/2; % ensuring H remains symmetric; do not delete!
        % =================================================================

        % =================================================================
        % The optimal change of the input trajectory du = duff +
        % K*dx 
        %
        duff(:,k) = -inv(H)*g;
        K(:,:,k) = -inv(H)*G;
        % =================================================================

        % =================================================================
        % [Todo] Solve Riccati-like equations for current time step n
        % (Problem 1.1 (g))
        %
        Sm(:,:,k) = Qm + A'*Sm(:,:,k+1)*A + K(:,:,k)'*H*K(:,:,k) + K(:,:,k)'*G + ...
            G'*K(:,:,k);
        Sv(:,k) = Qv + A'*Sv(:,k+1) + K(:,:,k)'*H*duff(:,:,k) + K(:,:,k)'*g + G'*duff(:,:,k);
        s(k) = q + s(k+1) + 0.5*duff(:,:,k)'*H*duff(:,:,k) + duff(:,:,k)'*g;
        
        % =================================================================

    end % of backward pass for solving Riccati equation
    
    % define theta_ff in this function
    [u_ff,u_fb] = Update_Controller(X0,U0,duff,K);
    Controller.u_ff = u_ff;
    Controller.u_fb = u_fb;
    
    i = i+1;
end

% % simulating for the last update just to calculate the final cost
% sim_out    = Simulator(Model,Task,Controller);
cost(i) = Calculate_Cost(Sim_Out_ILQC, q_fun, qf_fun);
fprintf('Cost of Iteration %2d: %6.4f \n', i-1, cost(i));
end



function [u_ff,u_fb] = Update_Controller(X0,U0,dUff,K)
% UPDATE_CONTROLLER Updates the controller after every ILQC iteration
%
%  X0  - state trajectory generated with controller from previous 
%        ILQC iteration.
%  UO  - control input generated from previous ILQC iteration.
%  dUff- optimal update of feedforward input found in current iteration
%  K   - optimal state feedback gain found in current iteration
%
%  The updated control policy has the following form:
%  U1 = U0 + dUff + K(X - X0)
%     = U0 + dUff - K*X0 + K*X
%     =      Uff         + K*x
%  
%% Update Controller
% input and state dimensions
n  = size(X0,2); % dimension of state
m = size(U0,2); % dimension of control input
N  = size(X0,1); % number of time steps

% initialization
theta_fb = zeros(m, 1, N-1);
theta_ff = zeros(m, 1, N-1);

% =========================================================================
% [Todo] feedforward control input
%
%  U0 = permute(U0, [3, 1, 2]);
%  dUff = permute(dUff, [2, 1, 3]);
 KX0 = zeros(1, m, N-1);
 for i = 1:1:N-1
     KX0(:,:,i) = K(:,:,i)*X0(i,:)';
     theta_ff(:,:,i) = U0(i,:)' + dUff(:,:,i) - KX0(:,:,i)';
 end


% =========================================================================

% feedback gain of control input (size: n * m * N-1)
theta_fb = K;      

% puts below (adds matrices along first(=row) dimension). 
% (size: (n+1) * m * N-1)
u_ff = theta_ff;
u_fb = theta_fb;

end


function cost = Calculate_Cost(sim_out, q_fun, qf_fun)
% CALCULATE_COST: calcules the cost of current state and input trajectory
% for the current ILQC cost function. Not neccessarily the same as the LQR
% cost function.

X0 = sim_out.x(1:end-1,:);
xf = sim_out.x(end,:);
n = size(X0,1);
U0 = sim_out.u(1:n,:);
T0 = sim_out.t(1:end-1);

cost = sum(q_fun(T0',X0',U0')) + qf_fun(xf');
end

function xskew = skew(x)

xskew = [0 -x(3) x(2);
    x(3) 0 -x(1);
    -x(2) x(1) 0];
end
