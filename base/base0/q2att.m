function att = q2att(qnb)
% Convert attitude quaternion to Euler attitude angles.
%
% Prototype: att = q2att(qnb)
% Input: qnb - attitude quaternion
% Output: att - Euler angles att=[pitch; roll; yaw] in radians
%
% See also  a2mat, a2qua, m2att, m2qua, q2mat, q2att1, attsyn, q2rv.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 21/02/2008, 28/01/2013

%     att = m2att(q2cnb(qnb));

    q11 = qnb(1)*qnb(1); q12 = qnb(1)*qnb(2); q13 = qnb(1)*qnb(3); q14 = qnb(1)*qnb(4); 
    q22 = qnb(2)*qnb(2); q23 = qnb(2)*qnb(3); q24 = qnb(2)*qnb(4);     
    q33 = qnb(3)*qnb(3); q34 = qnb(3)*qnb(4);  
    q44 = qnb(4)*qnb(4);
    C12=2*(q23-q14);
    C22=q11-q22+q33-q44;
    C31=2*(q24-q13); C32=2*(q34+q12); C33=q11-q22-q33+q44;
    att = [ asin(C32); 
            atan2(-C31,C33); 
            atan2(-C12,C22) ];
    