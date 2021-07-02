function q = qmul(q1, q2)
% Quaternion multiplication: q = q1*q2.
% 
% Prototype: q = qmul(q1, q2)
% Inputs: q1, q2 - input quaternion
% Output: q - output quaternion ,such that q = q1*q2
%
% See also  qconj, qmulv, qupdt, qnormlz, lq2m, rq2m.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 22/11/2007   
    q = [ q1(1) * q2(1) - q1(2) * q2(2) - q1(3) * q2(3) - q1(4) * q2(4);
          q1(1) * q2(2) + q1(2) * q2(1) + q1(3) * q2(4) - q1(4) * q2(3);
          q1(1) * q2(3) + q1(3) * q2(1) + q1(4) * q2(2) - q1(2) * q2(4);
          q1(1) * q2(4) + q1(4) * q2(1) + q1(2) * q2(3) - q1(3) * q2(2) ];
