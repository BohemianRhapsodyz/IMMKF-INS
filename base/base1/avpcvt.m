function avp = avpcvt(avp)
% avp convension from degree to rad.
%
% Prototype: avp = avpcvt(avp)
% Input:  avp - att/lat/lon in degree,
%               where yaw ranging [0,360]*deg clockwise
% Output: avp - att/lat/lon in rad, 
%               where yaw ranging [-pi,pi] conter-clockwise
%
% See also  yawcvt.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 17/03/2018
global glv
    avp(:,[1:3,7:8]) = avp(:,[1:3,7:8])*glv.deg;
    avp(:,3) = yawcvt(avp(:,3),'c360cc180');