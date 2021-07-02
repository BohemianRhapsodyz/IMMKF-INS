function [att, Cnb] = q2att1(qnb)
% Convert attitude quaternion to Euler attitude angles.
% NOTE: the output Euler angle sequence is pitch->yaw->roll, 
% which is always used by launch vehicle.
%
% Prototype: att = q2att1(qnb)
% Input: qnb - attitude quaternion
% Output: att - Euler angles att=[pitch; roll; yaw] in radians
%
% See also  a2qua1, q2att.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 21/02/2008, 28/01/2013
%     q11 = qnb(1)*qnb(1); q12 = qnb(1)*qnb(2); q13 = qnb(1)*qnb(3); q14 = qnb(1)*qnb(4); 
%     q22 = qnb(2)*qnb(2); q23 = qnb(2)*qnb(3); q24 = qnb(2)*qnb(4);     
%     q33 = qnb(3)*qnb(3); q34 = qnb(3)*qnb(4);  
%     q44 = qnb(4)*qnb(4);
%     C11 = q11+q22-q33-q44; C12 = 2*(q23-q14); C13 = 2*(q24+q13); % q2cnb
%     C22 = q11-q22+q33-q44;
%     C32 = 2*(q34+q12);
%     att = [ atan2(C32,C22);
%             atan2(C13,C11); 
%             -asin(C12) ];
    Cnb = q2mat(qnb);
    att = [ atan2(Cnb(2,1),Cnb(1,1));
            atan2(Cnb(3,2),Cnb(3,3)); 
            -asin(Cnb(3,1)) ];
