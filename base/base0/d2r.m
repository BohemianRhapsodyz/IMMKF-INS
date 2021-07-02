function rad = d2r(deg)
% Convert angle unit from degree to radian
%
% Prototype: rad = d2r(deg)
% Input: deg - angle in degree(s)
% Output: rad - angle in radian(s)
%
% See also  r2d, r2dm, r2dms, dm2r, dms2r

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 30/10/2010
global glv
    rad = deg*glv.deg;
