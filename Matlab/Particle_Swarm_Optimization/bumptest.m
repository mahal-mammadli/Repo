function y = bumptest(xx)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUT:
%
% xx = [x1, x2, ..., xd]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

d = length(xx);
sum1 = 0;
product = 1;
sum2 = 0;
for ii = 1:d
	xi = xx(ii);
    product = product*cos(xi)^2;
	sum1 = sum1 + cos(xi)^4;
    sum2 = sum2 + ii*xi^2;

end

y = -abs(sum1-2*product)/sqrt(sum2);

end


