function att = m2att(Cnb)
% Convert direction cosine matrix(DCM) to Euler attitude angles.
%
% Prototype: att = m2att(Cnb)
% Input: Cnb - DCM from body-frame to navigation-frame
% Output: att - att=[pitch; roll; yaw] in radians
%
% See also  a2mat, a2qua, m2qua, q2att, q2mat, attsyn, m2rv.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 21/02/2008
    att = [ asin(Cnb(3,2)); 
            atan2(-Cnb(3,1),Cnb(3,3)); 
            atan2(-Cnb(1,2),Cnb(2,2)) ];
