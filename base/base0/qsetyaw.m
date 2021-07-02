function qo = qsetyaw(qi, yaw)
% Yaw angle reset in quaternion.
% 
% Prototype: qo = qsetyaw(qi, yaw)
% Inputs: qi - input quaternion
%         yaw - yaw angle
% Output: qo - output quaternion
% 
% See also  q2att, a2qua.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 17/06/2018
    att = q2att(qi);
    att(3) = yaw;
    qo = a2qua(att);
