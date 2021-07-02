function trj = trjNorth(avp0, ts, T)
% Under perfect-sphere Earth model, trajectory simulation with 
% north-south motion only, i.e., uniform velocity vN = vN0. 
% In this case, we can get analytical avp & IMU results, where VE=VU=0; 
% Euler angles, latitude & heigth are all constant; etc.
%
% Prototype: trj = trjNorth(avp0, ts, T)
% Inputs: avp0 - initial avp
%         ts, T - sampling interval & simulation time length
% Output: trj - array structure includes fields: imu, avp, avp0 & ts
%
% See also  trjEast, trjunilat, trjSimu.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 22/05/2014
global glv
    att0 = avp0(1:3); vn0 = avp0(4:6); pos0 = avp0(7:9);
    b0 = vn0(2); L0 = avp0(7);
    eth = earth(pos0);  wie = glv.wie; g = -eth.gn(3);  RMh = eth.RMh;
    t = (0:ts:T)'; slbt = sin(L0+b0/RMh*t); clbt = cos(L0+b0/RMh*t);
    vN = b0+0*t;   % north-south velocity
    wx = -b0/RMh*t;
    wy = wie*RMh/b0*(slbt-sin(L0));
    wz = -wie*RMh/b0*(clbt-cos(L0));
    fccx = 2*wie*RMh*(clbt-cos(L0));
    fccy = (wie*RMh)^2/(4*b0)*(cos(2*(L0+b0/RMh*t))-cos(2*L0))*0;
    fccz = -b0^2/RMh*t;
    imu = [wx, wy, wz, fccx, fccy, g*t+fccz];  % total increments, approximating az
    imu = [diff(imu), t(2:end)]; % increments in interval 'ts'
    Cbn = a2mat(att0)';
    imu(:,1:6) = [Cbn*imu(:,1:3)'; Cbn*imu(:,4:6)']'; % n->b0 frame
    att = repmat(att0', length(t)-1, 1); % constant Euler angles
    vn = [t(2:end)*0, vN(2:end), t(2:end)*0]; % velocity, VE=VU=0
    pos = repmat(pos0', length(t)-1, 1); % position, lon=constant,hgt=constant
    pos(:,1) = pos(:,1) + b0/RMh*t(2:end); % latitude
    avp = [att, vn, pos, t(2:end)];
    trj = varpack(imu, avp, avp0, ts);
