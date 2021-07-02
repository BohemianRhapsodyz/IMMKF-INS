function [dms, dms_array] = r2dms(rad)
% Convert angle unit from radian to degree+minute+second
%
% Prototype: [dms, dms_array] = r2dms(rad)
% Input: rad - angle in radian(s)
% Outputs: dms - angle in degree+minute
%          dms_array = [degree, minute, second] is a three-column vector
% Examples:
%    [dms, dmsa] = r2dms(0.6);
%       >> dms = 342238.883748258
%       >> dmsa = [34, 22, 38.8837482578072]
%    [dms, dmsa] = r2dms(-0.6);
%       >> dms = -342238.883748258
%       >> dmsa = [-34, 22, 38.8837482578072]
%
% See also  r2d, r2dm, d2r, dm2r, dms2r

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 30/10/2010
global glv
    s = sign(rad);
    rad = s.*rad;
    deg = rad/glv.deg;      d0 = fix(deg);
	min = (deg-d0)*60;      m0 = fix(min); 
	sec = (min-m0)*60;
	dms = s.*(d0*10000.0+m0*100.0+sec);
    if nargout==2
        dms_array = [s.*d0, m0, sec];
    end
