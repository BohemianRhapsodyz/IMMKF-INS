function d = cros3(a, b, c)
% The cross product of three 3-element vectors a,b and c, i.e. d=(axb)xc.
%
% Prototype: d = cros3(a, b, c)
% Inputs: a, b, c - 3-element vectors
% Output: d - d = (a x b) x c
%
% See also  cros.

% Copyright(c) 2009-2016, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 04/02/2016
    d = cros(cros(a,b), c);