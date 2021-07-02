function mq = rq2m(q)
% In quaternion multiplication: q = q1*q2, convert q2 to 4x4 matrix M(q2),
% so that q1*q2 equals M(q2)*q1, i.e. output mq = M(q2).
% 
% Prototype: mq = rq2m(q)
% Input: q - quaternion
% Output: mq - 4x4 matrix
%
% See also  lq2m, qmul, q2mat.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 18/03/2012   
    mq = [  q(1), -q(2), -q(3), -q(4);
            q(2),  q(1),  q(4), -q(3);
            q(3), -q(4),  q(1),  q(2);
            q(4),  q(3), -q(2),  q(1) ];