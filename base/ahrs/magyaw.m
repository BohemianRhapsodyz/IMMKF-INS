function yaw = magyaw(mag, att, declination)
% Geomagnetic yaw calculation.
%
% Prototype: yaw = magyaw(mag, att, declination)
% Inputs: mag - 3-axis geomagnetic
%         att - attitude/DCM/quaternion
%         declination - geomagnetic declination
% Output: yaw - geomagnetic yaw
%          
% See also  magplot.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 17/06/2018
    if ~exist('declination', 'var'), declination=0; end
    [~, att] = attsyn(att);  att(3) = 0;
    magH = a2mat(att)*mag;
	yaw = atan2(magH(1), magH(2)) + declination;
	if yaw>pi,       yaw = yaw - 2*pi;
    elseif yaw<-pi,  yaw = yaw + 2*pi;  end
