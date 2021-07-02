function incl = incline(att)
% Calculating angle of inclination from Euler algles, DCM or quaternion.
%
% Prototype: incl = incline(att)
% Input: att - Euler algles, DCM or quaternion
% Output: incl - angle of inclination
%
% See also  m2att.

% Copyright(c) 2009-2019, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 12/04/2019
    [m,n] = size(att);
    if m==4&&n==1, att=q2att(att)';
    elseif m==3&&n==3, att=m2att(att)';
    elseif m==3&&n==1, att=att'; end
    incl = acos(cos(att(:,1)).*cos(att(:,2)));
