function  ap = apmove(ap0, pos0, yaw0)
% Move original trajectory ap0 to a specific place, whose first point
% is at pos0 and initial yaw is yaw0.
%
% See also  avp2imu, trjsimu, insupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 16/03/2014
    if nargin<3,  yaw0=ap0(1,3);  end
    ap = ap0; 
    % rotate
    dyaw = yaw0 - ap0(1,3);
    dyaw = rem(dyaw,pi);
    ap(:,3) = ap0(:,3) + dyaw;
    idx = ap(:,3)>pi;  ap(idx,3) =  ap(idx,3) - 2*pi; % 13/3/2015
    idx = ap(:,3)<-pi; ap(idx,3) =  ap(idx,3) + 2*pi;
    clat0 = cos(ap0(1,4));
    xy = [(ap0(:,5)-ap0(1,5))*clat0, ap0(:,4)-ap0(1,4)];  % [dlon*cL,dlat]
    xy = xy*[cos(dyaw), sin(dyaw); -sin(dyaw), cos(dyaw)];
    % move
    ap(:,4:6) = [ xy(:,2)+pos0(1), ...
                  xy(:,1)/clat0*cos(pos0(1))+pos0(2), ...
                  ap0(:,6)+pos0(3) ];
  