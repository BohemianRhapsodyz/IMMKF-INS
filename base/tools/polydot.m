function c = polydot(a, b)
% The dot product of polynomial coefficient vectors a and b, i.e. c = a' * b,
% using convolution alogrithm.
%
% Prototype: c = polydot(a, b)
% Inputs: a, b - polynomial coefficient [mXn] vectors
% Output: c - c = a' * b, [1X(2n-1)] vectors
%
% See also  ploycross, cros, conv.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 21/10/2018
    c = 0;
    for k=1:size(a,1)
        c = c + conv(a(k,:), b(k,:));
    end