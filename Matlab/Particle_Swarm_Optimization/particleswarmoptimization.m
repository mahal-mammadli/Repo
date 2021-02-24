% Partical Swarm Optimization (PSO) algorithm
% 
% Template of a PSO algorithm:
% 1. Initialize a set of particles positions x0i
% and velocities v0i randomly distributed throughout the design space 
% bounded by specified limits
% 2. Evaluate the objective function values f(xki)of all particles
% 3. Update the optimum particle position pki at iteration k
% (personal best) and globally best particle position pkg
% 4. Update the position of each particle using its previous position
% and updated velocity vector
% 5. Repeat steps 2-4 until some stopping criteria are met.
%
% PSO algorithm parameters:
%
% r1, r2 ∼ U[0, 1] (random numbers)
% pki best position of particle i (personal best)
% pkg – swarm best particle position (global best)
% c1 – cognitive parameter (confidence in itself)
% c2 – social parameter (confidence in the swarm)
% w – inertial weight (inertia of a particle)
% xlb < x < xub - solution lower and upper bound constraints 
% g - inequality function 
% h - equality function
% p_max - max particle size
% i_max - max iteration count
% rho - penalty parameter
%
%
% How to implement:
%
% fun = @(x)x(1)*exp(-norm(x)^2);
% xlb = [-10,-15];    % subject to lower bounds, need to specify row vector
% xub = [15,20]; % subject to upper bound
% g = @(x) [-10-x(1),-15-x(2),x(1)-15,x(2)-20]; % bounds can also be written as
% h = @(x) 0; % h = 0 equality
% nvars = 2; % number of variables/dimension
% c1 = 1.5; % c1 tunning parameter
% c2 = 3; % c2 tunning parameter
% w = 0.3; % weight parameter
% rho = 0.01; % penalty function parameter
% p_max = 10; % number of swarm particles
% i_max = 10000; % number of max loop iterations
% [x, pkg, tloop, tend] = ...
% particleswarmoptimization(fun,nvars,g,h,xlb,xub,c1,c2,w,rho,p_max,i_max)

%
% PSO function implementation:
%
% [x, pkg, tloop, tend] = ...
% particleswarmoptimization(fun,nvars,g,h,xlb,xub,c1,c2,w,rho,p_max,i_max)

function [x, xbest, pkg, tloop, tend] = ...
    particleswarmoptimization(fun,nvars,g,h,xlb,xub,c1,c2,w,rho,p_max,i_max)
tstart = cputime;
% initial particles position and velocity
x = []; % x is defined as (particle size x nvars)
v = [];
% initialize objective function and iterations for plotting
objfunplot = [];
iteration_count = [];
xbest = [];
for i=1:1:nvars
    % random distribution between bounds
    x(:,i) = randi([xlb(i),xub(i)],p_max,1);
    v(:,i) = randi([0,1],p_max,1);
end
% quadratic penalty function definition
phi = @(x) sum(max(0,g(x)).^2) + sum(h(x));
for i=1:1:p_max
    % evaluate the initial objection function values
    objfunPv(i,:) = fun(x(i,:)) + phi(x(i,:));
    % intialize previous objection function values
    pkgPv(i,:) = min(objfunPv(i,:));
    % store previous state
    xPv(i,:) = x(i,:);
end
% optimization exit flag 
% (1 - finished)
exitFlag = 1;
converged = 0;
% k-th iteration timestep
k = 1;
% intialize particle personal best
i_pk = 0;
% intialize penalty parameter
alpha = 1;
% optimization loop to minimize objective function
while exitFlag
    for i=1:1:p_max
        % random number generated
        r1 = rand(p_max,nvars);
        r2 = rand(p_max,nvars);
        % loop through all particles
        for j=1:1:p_max
            % evaluate the objection function values pi(xki) of all particles
            obj_fun(j,:) = fun(x(j,:)) +  rho*phi(x(i,:));
        end
    
        % evalute particle global best
    	[pkg ,i_pkg] = min(obj_fun);
        if abs(pkgPv) < abs(pkg)
            i_pkg = i_pkgPv;
        end   
        % evaluate particle personal best
        pki = obj_fun(i,:);
        pkiPv = objfunPv(i,:);
        if abs(pkiPv) < abs(pki)
            i_pk = xPv(i,:);
        elseif abs(pki) < abs(pkiPv)
            i_pk = x(i,:);
        end     
        % evalute next velocity
        v(i,:) = w.*v(i,:) + c1.*r1(i,:).*(i_pk - x(i,:)) + c2.*r2(i,:).*(x(i_pkg,:) - x(i,:));
        % store previous state
        xPv(i,:) = x(i,:);
        % evalute next state
        x(i,:) = x(i,:) + v(i,:);
        
        % store states
        objfunPv(i,:) = obj_fun(i,:);
        pkgPv = pkg;
        i_pkgPv = i_pkg;
        rho = alpha*rho;
    end
    
    % Optimization status
    % Show state at every 100 iterations
    if ~mod(k,100)
        disp('Iteration:')
        disp(k)
        disp(x)        
    end  
    % checking optimization exit condition
    % all particles have converged
    converged = all(all(abs(x-xPv) < 1e-8)) || ...
        all(all(abs(obj_fun-objfunPv) < 1e-8));
    % iterations over 1000
    if k > i_max || converged
        xbest = x(i_pkg,:);
        exitFlag = 0;
        disp('Done.');        
    end
    % store previous objective function values
    objfunplot(:,k) = obj_fun;
    iteration_count(:,k) = k;
    k = k + 1;
    
end
% max iterations
max_iter = k-1;
%calculate loop execution time
tloop = cputime - tstart;

% plotting
figure();
plot(iteration_count(:,1:max_iter),mean(objfunplot(:,1:max_iter)));
title('Objective function vs iterations');
xlabel('[Iterations]');
ylabel('[Obj. function value]');
grid on;

% calculate total execution time
tend = cputime - tstart;
disp('Time [s]:')
disp(tend)
end

