function s = hms2s(hhmmss)
% Convert angle unit from degree+minute+second to radian
%
% Prototype: s = hms2s(hhmmss)
% Input: hhmmss - hh:hour, mm:min, ss:sec.
% Output: s - second
% Examples:
%    s = hms2s(123456.78);        
%       >>  s = 0.219604986542088
%
% See also  dms2r

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 15/05/2018
    hh = fix(hhmmss/10000.0);
    min = fix((hhmmss-hh*10000.0)/100.0); 
    sec = hhmmss-hh*10000.0-min*100.0;
	s = hh*3600+min*60+sec;

