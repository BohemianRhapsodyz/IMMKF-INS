function [n, rest] = ifactorial(val)
% Inverse factorial calculation, such that val = (n!)*rest.

% Prototype: [n, rest] = ifactorial(val)
% Input:   val - input value > 0
% Outputs: n - an integer
%          rest - remaining

% See also  N/A.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 04/02/2017
    rest = val;
    for n = 1:500
        rest = rest/n;
        if rest<(n+1)
            break;
        end
    end
%     test = val-factorial(n)*rest
    
