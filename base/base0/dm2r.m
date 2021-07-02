function rad = dm2r(dm)
% Convert angle unit from degree+minute to radian
%
% Prototype: rad = dm2r(dm)
% Input: dm - angle in degree+minute, 
%            NOTE: 'dm=1234.56' is equivalent to 'dm=[12, 34.56]', 
%                  they all mean '12 degrees + 34.56 minutes'.
% Output: rad - angle in radian(s)
% Examples:
%    r = dm2r(1234.56);        
%       >>  r = 0.219492606730807
%    r = dm2r([-12, 34.56]);   
%       >>  r = -0.219492606730807
%
% See also  r2d, r2dm, r2dms, d2r, dms2r

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 30/10/2010
global glv
    n = size(dm,2);
    s = sign(dm(:,1));
    if n==1   % rad = dm2r(dm)
        dm = s.*dm;
        deg = fix(dm/100.0);
        min = dm-deg*100.0; 
    else      % rad = dm2r([d,m])
        deg = s.*dm(:,1);
        min = dm(:,2);
    end
	rad = s.*(deg*glv.deg+min*glv.min);
