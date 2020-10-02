function [Controller,Cost] = AttitudeSimulation(Task,controller_type,optimal_controller_type,...
    disturbance_type,p,th,dth,p_d,dp_d,I,Fi,ilqc_itertation)

% Simulation time constants
dt = Task.dt; %s
n = Task.goal_time; %s

switch controller_type
    case 'PI'
        % Gains
            % may be modified
        Kp = 2;
        Kd = 0.5;
        
        uc = @(dth,p) -Kp*p - Kd*dth;
    case 'Optimal'
        % Cost matrices
            % may be modified
        Q = Task.cost.Q_lqr;
        R = Task.cost.R_lqr;
        
        A = [0 0 0 0.5 0 0;
            0 0 0 0 0.5 0;
            0 0 0 0 0 0.5;
            0 0 0 0 0 0;
            0 0 0 0 0 0;
            0 0 0 0 0 0];
        
        B = [0 0 0;
            0 0 0;
            0 0 0;
            1/I(1,1) 0 0;
            0 1/I(2,2) 0;
            0 0 1/I(3,3)];
        
        [K,~,~] = lqr(A,B,Q,R);        
        switch optimal_controller_type
            case 'inertial'
                % Linearized assumption
                % pdot = 0.5*dth;
                uc = @(dth,p,error_p,error_dp) -K(1:3,1:3)*p - K(1:3,4:6)*0.5*dth;
            case 'error'
                uc = @(dth,p,error_p,error_dp) -K(1:3,1:3)*error_p' - K(1:3,4:6)*error_dp';
            case 'tracking'
                uc = @(dth,p,error_p,error_dp) -K(1:3,1:3)*error_p' - K(1:3,4:6)*error_dp';        
        end
        
    case 'Error'
        % Gains
            % may be modified        
        Kp = 2;
        Kd = 0.5;
        uc = @(error_p,error_dp) -Kp*error_p - Kd*error_dp;
    case 'ILQC'
        % Getting LQR rollout to be used for ILQC
        controller_type = 'Optimal';
       [controller_lqr,cost_lqr] = AttitudeSimulation(Task,controller_type,optimal_controller_type,...
             disturbance_type,p,th,dth,p_d,dp_d,I,Fi);
       [controller_ilqc] = ILQC_Design(Task,controller_lqr,p,th,dth,p_d,dp_d,I,Fi);
%        uc = @(dth,p,error_p,error_dp,i) controller_ilqc.u_ff(:,:,i) + ...
%            controller_ilqc.u_fb(:,:,i)*[p; dth];
       uc = @(dth,p,error_p,error_dp,i) ...
           controller_ilqc.u_fb(:,:,i)*[p; dth];
%        uc = @(dth,p,error_p,error_dp,i) ...
%            controller_ilqc.u_fb(:,:,i)*[error_p error_dp]';
       
       controller_type = 'ILQC';
        
end

switch disturbance_type
    case 'none'
        ud = @(th,dt) 0;
    case 'linear'
        % may be modified
        ud1 = 0.1;
        ud2 = 0.1;
        ud3 = 0.1;
        
        ud = @(th,dt) [ud1;ud2;ud3];
end

% Total Input
switch controller_type
    case 'PI'
        u = @(dt,th,dth,p) uc(dth,p) + ud(th,dt);
    case 'Error'
        u = @(dt,th,error_dp,error_p) uc(error_dp,error_p) + ud(th,dt);
    case 'Optimal'
        u = @(dt,th,dth,p,error_p,error_dp) uc(dth,p,error_p,error_dp) + ud(th,dt);
    case 'ILQC'
        u = @(dt,th,dth,p,error_p,error_dp,i) uc(dth,p,error_p,error_dp,i) + ud(th,dt);
end

% Motion equations
switch controller_type
    case 'PI'
        ddth = @(th,dth,u,p) inv(I)*(u(dt,th,dth,p) - skew(dth)*I*dth);
    case 'Error'
        ddth = @(th,dth,u,error_dp,error_p) inv(I)*(u(dt,th,error_dp,error_p)- skew(dth)*I*dth);
    case 'Optimal'
        ddth = @(th,dth,u,p,error_p,error_dp) inv(I)*(u(dt,th,dth,p,error_p,error_dp)- skew(dth)*I*dth);
    case 'ILQC'
        ddth = @(th,dth,u,p,error_p,error_dp,i) inv(I)*(u(dt,th,dth,p,error_p,error_dp,i)- skew(dth)*I*dth);
end

% ER equation  
dp = @(dth,p) 0.5*(eye(3) + p*p' + skew(p))*dth;

% Error equations
    % ER error
er_p = @(p) p - p_d;
er_dp = @(dp) dp - dp_d;
    
% Loop completes the 4th order Runge Kutta integral
j = 1;
C = eye(3);
for i = 0:dt:n
    
    error_p(j,:)  = er_p(p);
    error_dp(j,:)  = er_dp(dp(dth,p));
    
    switch controller_type 
        case 'PI'
            k1 = dt*ddth(th,dth,u,p);
            k2 = dt*ddth(th+k1/2,dth,u,p);
            k3 = dt*ddth(th+k2/2,dth,u,p);
            k4 = dt*ddth(th+k3,dth,u,p);
    
            % Logging Control Input
            u_input(j,:) = u(dt,th,dth,p);
            u_disturb(j,:) = ud(th,dt);
        case 'Error'
            % Adusting error term, to compensate for desired omegas
            p_d = p_d + dp_d*dt;
            error_p(j,:) = p - p_d;     
                        
            k1 = dt*ddth(th,dth,u,error_p(j,:)',error_dp(j,:)');
            k2 = dt*ddth(th+k1/2,dth,u,error_p(j,:)',error_dp(j,:)');
            k3 = dt*ddth(th+k2/2,dth,u,error_p(j,:)',error_dp(j,:)');
            k4 = dt*ddth(th+k3,dth,u,error_p(j,:)',error_dp(j,:)');
    
            % Logging Control Input % disturbance torques
            u_input(j,:) = u(dt,th,error_dp(j,:)',error_p(j,:)');
            u_disturb(j,:) = ud(th,dt);
        case 'Optimal'
            switch optimal_controller_type
                case 'tracking'                    
                    % Adusting error term, to compensate for desired omegas
                    p_d = p_d + dp_d*dt;
                    error_p(j,:) = p - p_d;
                    
                    k1 = dt*ddth(th,dth,u,p,error_p(j,:),error_dp(j,:));
                    k2 = dt*ddth(th+k1/2,dth,u,p,error_p(j,:),error_dp(j,:));
                    k3 = dt*ddth(th+k2/2,dth,u,p,error_p(j,:),error_dp(j,:));
                    k4 = dt*ddth(th+k3,dth,u,p,error_p(j,:),error_dp(j,:));
                otherwise
                    % Adusting error term, to compensate for desired omegas
                    p_d = p_d + dp_d*dt;
                    error_p(j,:) = p - p_d;
                    
                    k1 = dt*ddth(th,dth,u,p,error_p(j,:),error_dp(j,:));
                    k2 = dt*ddth(th+k1/2,dth,u,p,error_p(j,:),error_dp(j,:));
                    k3 = dt*ddth(th+k2/2,dth,u,p,error_p(j,:),error_dp(j,:));
                    k4 = dt*ddth(th+k3,dth,u,p,error_p(j,:),error_dp(j,:));
            end
            % Logging Control Input
            u_input(j,:) = u(dt,th,dth,p,error_p(j,:),error_dp(j,:));
            u_disturb(j,:) = ud(th,dt);
        case 'ILQC'
            if (j < 201)
            % Adusting error term, to compensate for desired omegas
            p_d = p_d + dp_d*dt;
            error_p(j,:) = p - p_d;
                    
            k1 = dt*ddth(th,dth,u,p,error_p(j,:),error_dp(j,:),j);
            k2 = dt*ddth(th+k1/2,dth,u,p,error_p(j,:),error_dp(j,:),j);
            k3 = dt*ddth(th+k2/2,dth,u,p,error_p(j,:),error_dp(j,:),j);
            k4 = dt*ddth(th+k3,dth,u,p,error_p(j,:),error_dp(j,:),j);
            
            % Logging Control Input
            u_input(j,:) = u(dt,th,dth,p,error_p(j,:),error_dp(j,:),j);
            u_disturb(j,:) = ud(th,dt);
            end
    end
    % Omega update
    dth = dth + (k1 + 2*k2 + 2*k3 + k4)/6;
           
    p = p + dp(dth,p)*dt;
    % Rotation matrix
    C = ((1 - p'*p)*eye(3) + 2*p*p' - 2*skew(p)) / (1 + p'*p);
    % Rotation
    for k=1:1:3
        Fb(:,k) = C*Fi(:,k);
    end
    F(:,:,j) = [0 0 0;Fb(:,1)';0 0 0;Fb(:,2)';0 0 0;Fb(:,3)'];         
    
    % Updating EA
    th = th + dth*dt;
    % Logging data for plotting
    p_sim(j,:) = p';
    dth_sim(j,:) = dth;
    dp_sim(j,:) = dp(dth,p)';
    theta(j,:) = th;
    t(j,:) = i;
        
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

% Cost
Cost = Calculate_Cost(Controller, Task);

end

function xskew = skew(x)

xskew = [0 -x(3) x(2);
    x(3) 0 -x(1);
    -x(2) x(1) 0];
end

% LQR COST 
function Cost = Calculate_Cost(controller, Task)
% Calculate_Cost(.) Asses the cost of a rollout sim_out 
%
%   Be sure to correctly define the equilibrium state (X_eq, U_eq) the 
%   controller is trying to reach.
X = [controller.p_sim controller.dth_sim];
U = controller.u_input;
Q = Task.cost.Q_lqr;
R = Task.cost.R_lqr;
X_eq = Task.cost.x_eq'; % equilibrium state controller tries to reach
U_eq = Task.cost.u_eq';   % equilibrium input controller tries to reach
Ex = X - X_eq;                    % error in state
Eu = U - U_eq;                               % error in input

Cost = Task.dt * (sum(sum((Ex*Q.*Ex),1)) + sum(sum((Eu*R.*Eu),1)));
end