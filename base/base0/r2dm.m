function [dm, dm_array] = r2dm(rad)
% Convert angle unit from radian to degree+minute
%
% Prototype: [dm, dm_array] = r2d(rad)
% Input: rad - angle in radian(s)
% Outputs: dm - angle in degree+minute
%          dm_array = [degree, minute] is a two-column vector
% Examples:
%    [dm, dma] = r2dm(0.6);
%       >> dm = 3422.64806247096
%       >> dma = [34, 22.6480624709635]
%    [dms, dmsa] = r2dm(-0.6);
%       >> dms = -3422.64806247096
%       >> dmsa = [-34, 22.6480624709635]
%
% See also  r2d, r2dms, d2r, dm2r, dms2r

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 30/10/2010
global glv
    s = sign(rad);
    rad = s.*rad;
    deg = rad/glv.deg;      d0 = fix(deg);
	min = (deg-d0)*60;
	dm = s.*(d0*100.0+min);
    if nargout==2
        dm_array = [s.*d0, min];
    end
