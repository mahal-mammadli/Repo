function [y] = inverse_problem(x,do_plot)

% decompose input
c = x(1);
k = x(2);
% given parameters
F0 = 1;
w = 0.1;
m = 1;
% measured response
persistent y_meas t
if isempty(y_meas)
    y_meas = load('MeasuredResponse.dat'); % [t,y]
    t = y_meas(:,1);
end
% analytical equations
alpha = atan(c*w/(k - m*w^2));
wd = sqrt(k/m - (c/2*m)^2);
C = sqrt((k - m*w^2)^2+(c*w)^2);
B = -(F0/(C*wd))*(w*sin(alpha)+(c/2*m)*cos(alpha));
A = -(F0/C)*cos(alpha);
y_analytical = (A*cos(wd.*t)+B*sin(wd.*t)).*exp((-c.*t)/(2*m))+(F0/C).*cos(w.*t-alpha);
% error
y = sum(abs(y_analytical - y_meas(2)));
% plot
if ~exist('do_plot','var')
else
    plot(t,y_analytical)
    hold on;
    grid on;
    plot(t,y_meas(:,2))
    legend('Analytical','Measured')
    xlabel('Time [s]');
    ylabel('Displacement [y]');
end
end