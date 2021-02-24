Particle Swarm Optimization Matlab Implementation:

Inputs:

1. Define function m file:
	[y] = rosen(xx)
	fun = @(x) rosen(x);
- Note zip files comes with all required functions already defined. 
2. Define upper and lower bounds for EACH dimension:
	xlb = [-5,-5];    % subject to lower bounds, need to specify row vector
	xub = [5,5]; % subject to upper bound

3. Define inequlities for EACH dimension:
	g = @(x) [-x(1)-5,-x(2)-5,x(1)-5,x(2)-5];
	h = @(x) 0; % h = 0 equality
4. Define the number of variables/dimension
	nvars = 2; % number of variables/dimension

5. Tuning parameters:
	c1 = 1; % c1 tunning parameter
	c2 = 3; % c2 tunning parameter
	w = 0.005; % weight parameter
	rho = 0.01; % penalty function parameter
	p_max = 10; % number of swarm particles
	i_max = 10000; % number of max loop iterations
6. PSO function implementation:

	[x, xbest, pkg, tloop, tend] = ...
		particleswarmoptimization(fun,nvars,g,h,xlb,xub,c1,c2,w,rho,p_max,i_max);

Outputs:
x - final solution of all particles
xbest - best solution from set of x
pkg - best objective function value including penalty function
tloop - time for optimization loop to execute
tend - time for PSO algorithm from start to finish including plotting.
