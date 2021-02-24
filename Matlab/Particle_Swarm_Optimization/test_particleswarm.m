%% AER1415 Computational Optimization Assignment 1 Case Studies
%
%
%% P1 n = 2
clear

fun = @(x) rosen(x);
xlb = [-5,-5];    % subject to lower bounds, need to specify row vector
xub = [5,5]; % subject to upper bound
g = @(x) [-x(1)-5,-x(2)-5,x(1)-5,x(2)-5]; % bounds can also be written as
h = @(x) 0; % h = 0 equality
nvars = 2; % number of variables/dimension
c1 = 1; % c1 tunning parameter
c2 = 3; % c2 tunning parameter
w = 0.005; % weight parameter
rho = 0.01; % penalty function parameter
p_max = 10; % number of swarm particles
i_max = 10000; % number of max loop iterations
[x, xbest, pkg, tloop, tend] = ...
particleswarmoptimization(fun,nvars,g,h,xlb,xub,c1,c2,w,rho,p_max,i_max)

%% P1 n = 5
clear

fun = @(x) rosen(x);
xlb(:,1:5) = -5;    % subject to lower bounds, need to specify row vector
xub(:,1:5) = 5; % subject to upper bound
g = @(x) [-x-5,x-5]; % bounds can also be written as
h = @(x) 0; % h = 0 equality
nvars = 5; % number of variables/dimension
c1 = 1; % c1 tunning parameter
c2 = 3; % c2 tunning parameter
w = 0.005; % weight parameter
rho = 0.01; % penalty function parameter
p_max = 10; % number of swarm particles
i_max = 10000; % number of max loop iterations
[x, xbest, pkg, tloop, tend] = ...
particleswarmoptimization(fun,nvars,g,h,xlb,xub,c1,c2,w,rho,p_max,i_max)

%% P2 n = 2
clear

for i=1:1:10
fun = @(x) rastr(x);
xlb = [-5,-5];    % subject to lower bounds, need to specify row vector
xub = [5,5]; % subject to upper bound
g = @(x) [-x(1)-5,-x(2)-5,x(1)-5,x(2)-5]; % bounds can also be written as
h = @(x) 0; % h = 0 equality
nvars = 2; % number of variables/dimension
c1 = 1; % c1 tunning parameter
c2 = 3; % c2 tunning parameter
w = 0.005; % weight parameter
rho = 0.01; % penalty function parameter
p_max = 10; % number of swarm particles
i_max = 10000; % number of max loop iterations
[x, xbest, pkg, tloop, tend] = ...
particleswarmoptimization(fun,nvars,g,h,xlb,xub,c1,c2,w,rho,p_max,i_max)
x_b(i,1:nvars) = xbest;
pkg_t(:,i) = pkg;
tloop_t(:,i) = tloop;
end
T = table(x_b,pkg_t',tloop_t');
T.x_b = round(T.x_b,5);
T.Var2 = round(T.Var2,5);
T.Var3 = round(T.Var3,5);
%% P2 n = 5
clear

for i=1:1:10
fun = @(x) rastr(x);
xlb(:,1:5) = -5;    % subject to lower bounds, need to specify row vector
xub(:,1:5) = 5; % subject to upper bound
g = @(x) [-x-5,x-5]; % bounds can also be written as
h = @(x) 0; % h = 0 equality
nvars = 5; % number of variables/dimension
c1 = 1; % c1 tunning parameter
c2 = 3; % c2 tunning parameter
w = 0.005; % weight parameter
rho = 0.01; % penalty function parameter
p_max = 10; % number of swarm particles
i_max = 10000; % number of max loop iterations
[x, xbest, pkg, tloop, tend] = ...
particleswarmoptimization(fun,nvars,g,h,xlb,xub,c1,c2,w,rho,p_max,i_max)
x_b(i,1:nvars) = xbest;
pkg_t(:,i) = pkg;
tloop_t(:,i) = tloop;
end
T = table(x_b,pkg_t',tloop_t');
T.x_b = round(T.x_b,5);
T.Var2 = round(T.Var2,5);
T.Var3 = round(T.Var3,5);

%% P3
clear

for i=1:1:10
fun = @(x) x(1)^2+0.5*x(1)+3*x(1)*x(2)+5*x(2)^2;
xlb = [-1,-1];    % subject to lower bounds, need to specify row vector
xub = [1,1]; % subject to upper bound
g = @(x) [3*x(1)+2*x(2)+2,15*x(1)-3*x(2)-1]; % bounds can also be written as
h = @(x) 0; % h = 0 equality
nvars = 2; % number of variables/dimension
c1 = 1; % c1 tunning parameter
c2 = 3; % c2 tunning parameter
w = 0.005; % weight parameter
rho = 0.01; % penalty function parameter
p_max = 10; % number of swarm particles
i_max = 10000; % number of max loop iterations
[x, xbest, pkg, tloop, tend] = ...
particleswarmoptimization(fun,nvars,g,h,xlb,xub,c1,c2,w,rho,p_max,i_max)
x_b(i,1:nvars) = xbest;
pkg_t(:,i) = pkg;
tloop_t(:,i) = tloop;
end
T = table(x_b,pkg_t',tloop_t');
T.x_b = round(T.x_b,5);
T.Var2 = round(T.Var2,5);
T.Var3 = round(T.Var3,5);

%% P4 Bump Test n = 2
clear

for i=1:1:10
fun = @(x) bumptest(x);
xlb = [0,0];    % subject to lower bounds, need to specify row vector
xub = [10,10]; % subject to upper bound
g = @(x) [-x(1)*x(2)+0.75,-x(1)*x(2)+0.75,(x(1)+x(2))-15,(x(1)+x(2))-15]; % bounds can also be written as
h = @(x) 0; % h = 0 equality
nvars = 2; % number of variables/dimension
c1 = 1; % c1 tunning parameter
c2 = 3; % c2 tunning parameter
w = 0.005; % weight parameter
rho = 0.01; % penalty function parameter
p_max = 10; % number of swarm particles
i_max = 10000; % number of max loop iterations
[x, xbest, pkg, tloop, tend] = ...
particleswarmoptimization(fun,nvars,g,h,xlb,xub,c1,c2,w,rho,p_max,i_max)
x_b(i,1:nvars) = xbest;
pkg_t(:,i) = pkg;
tloop_t(:,i) = tloop;
end
T = table(x_b,pkg_t',tloop_t');
T.x_b = round(T.x_b,5);
T.Var2 = round(T.Var2,5);
T.Var3 = round(T.Var3,5);

%% P4 Bump Test n = 10
clear

for i=1:1:10
fun = @(x) bumptest(x);
xlb(:,1:10) = 0;    % subject to lower bounds, need to specify row vector
xub(:,1:10) = 10; % subject to upper bound
g = @(x) [-prod(x)+0.75,(sum(x))-15]; % bounds can also be written as
h = @(x) 0; % h = 0 equality
nvars = 10; % number of variables/dimension
c1 = 1; % c1 tunning parameter
c2 = 3; % c2 tunning parameter
w = 0.005; % weight parameter
rho = 0.01; % penalty function parameter
p_max = 10; % number of swarm particles
i_max = 10000; % number of max loop iterations
[x, xbest, pkg, tloop, tend] = ...
particleswarmoptimization(fun,nvars,g,h,xlb,xub,c1,c2,w,rho,p_max,i_max)
x_b(i,1:nvars) = xbest;
pkg_t(:,i) = pkg;
tloop_t(:,i) = tloop;
end
T = table(x_b,pkg_t',tloop_t');
T.x_b = round(T.x_b,5);
T.Var2 = round(T.Var2,5);
T.Var3 = round(T.Var3,5);

%% P4 with n = 50;
clear

fun = @(x) bumptest(x);
xlb(:,1:50) = 0;    % subject to lower bounds, need to specify row vector
xub(:,1:50) = 10; % subject to upper bound
g = @(x) [-prod(x)+0.75,sum(x)-15]; % bounds can also be written as
h = @(x) 0; % h = 0 equality
nvars = 50; % number of variables/dimension
c1 = 1; % c1 tunning parameter
c2 = 3; % c2 tunning parameter
w = 0.005; % weight parameter
rho = 0.01; % penalty function parameter
p_max = 10; % number of swarm particles
i_max = 10000; % number of max loop iterations
[x, xbest, pkg, tloop, tend] = ...
particleswarmoptimization(fun,nvars,g,h,xlb,xub,c1,c2,w,rho,p_max,i_max)

%% P5 Inverse Problem
clear

for i=1:1:10
fun = @(x) inverse_problem(x);
xlb = [0,0];    % subject to lower bounds, need to specify row vector
xub = [1,12]; % subject to upper bound
g = @(x) [x(1)-1,x(2)-12]; % bounds also written as
h = @(x) 0; % h = 0 equality
nvars = 2; % number of variables/dimension
c1 = 0.25; % c1 tunning parameter
c2 = 1.0; % c2 tunning parameter
w = 0.05; % weight parameter
rho = 0.001; % penalty function parameter
p_max = 10; % number of swarm particles
i_max = 10000; % max number of iterations

[x, xbest, pkg, tloop, tend] = ...
particleswarmoptimization(fun,nvars,g,h,xlb,xub,c1,c2,w,rho,p_max,i_max)
x_b(i,1:nvars) = xbest;
pkg_t(:,i) = pkg;
tloop_t(:,i) = tloop;

inverse_problem(x(1,:),1)
end
T = table(x_b,pkg_t',tloop_t');
T.x_b = round(T.x_b,5);
T.Var2 = round(T.Var2,5);
T.Var3 = round(T.Var3,5);


inverse_problem(x(1,:),1)