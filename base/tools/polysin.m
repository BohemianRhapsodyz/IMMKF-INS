function [s, c] = polysin(w, n)
% Taylor polynomial coefficients for sin(w*t),cos(w*t).
% i.e. sin(w*t) = [ ... , 0, -w^3/3!, 0, w^1/1!, 0 ]
%      cos(w*t) = [ ... , w^4/4!, 0, -w^2/2!, 0, 1 ]

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 22/10/2018
    if ~exist('n', 'var'), n=10; end
    if ~exist('w', 'var'), w=1.0; end
    n1 = n + 1;
    s = zeros(1, n1);
    for k=1:2:n
        s(end-k) = (-1)^((k-1)/2) * w^k / factorial(k);
    end
    if nargout>1
        c = -polyint(s); c = [c(2:end-1),1];
    end