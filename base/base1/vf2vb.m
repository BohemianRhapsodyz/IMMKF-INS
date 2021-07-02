function vb = vf2vb(vf, dyaw, dpitch)
% Transfer forward velocity along vehicle body to body frame velocity(vector).
%
% Prototype: vb = vf2vb(vf, dyaw, dpitch)
% Inputs: vf - forward velocity(scale)
%         dyaw - yaw misalignment angle
%         dpitch - pitch misalignment angle
% Output: vb - body frame velocity(right-forward-up vector)
%
% See also  drPrj.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 30/08/2014
    if nargin<3, dpitch=0; end
    if nargin<2, dyaw=0; end
    sy = sin(dyaw); cy = cos(dyaw); sp = sin(dpitch); cp = cos(dpitch);
    if length(vf)==1
        vb = [sy*cp; cy*cp; sp]*vf;
    else
        vb = [sy*cp*vf, cy*cp*vf, sp*vf];
    end

