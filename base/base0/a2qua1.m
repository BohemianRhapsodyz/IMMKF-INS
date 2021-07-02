function [qnb, Cnb] = a2qua1(att)
% Convert Euler angles to attitude quaternion.
% NOTE: the input Euler angle sequence is pitch->yaw->roll, 
% which is always used by launch vehicle.
%
% Prototype: qnb = a2qua1(att)
% Input: att - att=[pitch; roll; yaw] in radians
% Output: qnb - attitude quaternion
%
% See also  q2att1, a2qua.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 13/09/2014

    s = sin(att); c = cos(att);
    si = s(1); sj = s(2); sk = s(3); 
    ci = c(1); cj = c(2); ck = c(3);
    Cnb = [ ci*ck, -si*cj+ci*sj*sk,  si*sj+ci*cj*sk;
            si*ck,  ci*cj+si*sj*sk, -ci*sj+si*cj*sk;
           -sk,     sj*ck,           cj*ck           ];
    qnb = m2qua(Cnb);

