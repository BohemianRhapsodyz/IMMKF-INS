function rad = dms2r(dms)
% Convert angle unit from degree+minute+second to radian
%
% Prototype: rad = dms2r(dms)
% Input: dms - angle in degree+minute+second, 
%            NOTE: 'dms=123456.78' is equivalent to 'dm=[12, 34, 56.78]', 
%                  they all mean '12 degrees + 34 minutes + 56.78 seconds'.
% Output: rad - angle in radian(s)
% Examples:
%    r = dms2r(123456.78);        
%       >>  r = 0.219604986542088
%    r = dms2r([-12, 34, 56.78]);   
%       >>  r = -0.219604986542088
%
% See also  r2d, r2dm, r2dms, d2r, dm2r

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 30/10/2010
global glv
    n = size(dms,2);
    s = sign(dms(:,1));
    if n==1   % rad = dm2r(dms)
        dms = s.*dms;
        deg = fix(dms/10000.0);
        min = fix((dms-deg*10000.0)/100.0); 
        sec = dms-deg*10000.0-min*100.0;
    else    % rad = dm2r([d,m,s])
        deg = s.*dms(:,1);
        min = dms(:,2);
        sec = dms(:,3);
    end
	rad = s.*(deg*glv.deg+min*glv.min+sec*glv.sec);

