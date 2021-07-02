function trj = trjEast1(avp0, a, f, ts, T)
% Trajectory simulation with east-west motion only, i.e., 
% vE = vE0 + a*sin(w*t). In this case, we can get analytical avp &
% IMU results, where VN=VU=0; Euler angles, latitude & heigth are all
% constant; omega^n_E=0; etc.
%
% Prototype: trj = trjEast(avp0, a, f, ts, T)
% Inputs: avp0 - initial avp
%         a, f - east-west sinusoidal velocity amplitude & frequency
%         ts, T - sampling interval & simulation time length
% Output: trj - array structure includes fields: imu, avp, avp0 & ts
%
% See also  trjSimu.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 19/05/2014
    att0 = avp0(1:3); vn0 = avp0(4:6); pos0 = avp0(7:9);
    b = vn0(1); w = 2*pi*f;
    eth = earth(pos0);
    tl = eth.tl; wN = eth.wnie(2); g = -eth.gn(3);
    RNh = eth.RNh; clRNh = eth.clRNh;
    t = (0:ts:T)'; swt = sin(w*t); cwt = cos(w*t);
    vE = b+a*swt;   % east-west velocity
    wy = (wN+b/RNh)*t-a/(w*RNh)*cwt;  % omega^n_N
    fccz = -(2*wN*b+b^2/RNh)*t+2*(wN+b/RNh)*a/w*cwt- ...
        a^2/(4*w*RNh)*(2*w*t-sin(2*w*t));
    imu = [t*0, wy, tl*wy, vE, -tl*fccz, g*t+fccz];  % total increments
    imu = [diff(imu), t(2:end)]; % increments in interval 'ts'
    Cbn = a2mat(att0)';
    imu(:,1:6) = [Cbn*imu(:,1:3)'; Cbn*imu(:,4:6)']'; % n->b frame
    att = repmat(att0', length(t)-1, 1); % constant Euler angles
    vn = [vE(2:end), t(2:end)*0, t(2:end)*0]; % velocity, VN=VU=0
    pos = repmat(pos0', length(t)-1, 1); % position, lat=constant,hgt=constant
    pos(:,2) = pos(:,2)+b/clRNh*t(2:end)-a/(w*clRNh)*(cwt(2:end)-1); % longitude
    avp = [att, vn, pos, t(2:end)];
    trj = varpack(imu, avp, avp0, ts);
