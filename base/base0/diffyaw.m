function dyaw = diffyaw(yaw1, yaw0)
% Yaw diff between yaw1 & yaw0.
%
% Prototype: dyaw = diffyaw(yaw1, yaw0)
% Inputs: yaw1 - computed yaw
%         yaw0 - reference yaw
% Output: dyaw - Yaw diff with [-pi,pi]
%
% See also  aa2phi, aa2mu.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 02/07/2018
    dyaw = yaw1 - yaw0;
    idx = dyaw>pi;
    dyaw(idx) = dyaw(idx) - 2*pi;
    idx = dyaw<-pi;
    dyaw(idx) = dyaw(idx) + 2*pi;
