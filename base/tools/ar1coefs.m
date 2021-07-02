function [b, a] = ar1coefs(ts, tau)
% AR(1) filter design, with the following model:
%   y(n) = a2*y(n-1) + b1*x(n)  i.e.  H(z) = b1/(1-a2*z^-1)
%
% Prototype: [b, a] = ar1coefs(ts, tau)
% Inputs: ts - sampling time interval
%         tau - filter correlation time (or time vector)
% Outputs: b - b = b1
%          a - a = [1, -a2]
%
% Example:
%   [b, a] = ar1coefs(1, 10);
%   x = ones(100, 1);
%   y = filter(b, a, x);
%   figure; plot([x, y]); grid on;
%
% See also  markov1.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 16/06/2014
    a2 = exp(-ts./tau(:));
    b = 1-a2;
    a = [ones(size(a2)), -a2];