function rv = qq2rv(q1, q0)
% Calculate rotation vector from attitude quaternions, such that q1=qmul(q0,rv2q(rv)).
%
% Prototype: rv = qq2rv(q1, q0)
% Inputs: q1 - attitude quaternion at current step
%         q0 - attitude quaternion at previous step
% Output: rv - rotation vector from q0 to q1
%
% See also  q2rv, qq2phi.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 13/02/2017
    rv = q2rv(qmul(qconj(q0),q1));
