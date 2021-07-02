function deg = r2d(rad)
% Convert angle unit from radian to degree
%
% Prototype: deg = r2d(rad)
% Input: rad - angle in radian(s)
% Output: deg - angle in degree(s)
%
% See also  r2dm, r2dms, d2r, dm2r, dms2r

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 30/10/2010
global glv
    deg = rad/glv.deg;
