function trj = trjEast(avp0, b1, a, f, ts, T)
% Trajectory simulation with east-west motion only, i.e., 
% vE = vE0 + b1*t + a*sin(w*t). In this case, we can get analytical avp
% & IMU results, where VN=VU=0; Euler angles, latitude & heigth are all
% constant; omega^n_E=0; etc.
%
% Prototype: trj = trjEast(avp0, b1, a, f, ts, T)
% Inputs: avp0 - initial avp
%         b1 - east-west acceleration
%         a, f - east-west sinusoidal velocity amplitude & frequency
%         ts, T - sampling interval & simulation time length
% Output: trj - array structure includes fields: imu, avp, avp0 & ts
%
% See also  trjNorth, trjunilat, trjSimu.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 19/05/2014
    att0 = avp0(1:3); vn0 = avp0(4:6); pos0 = avp0(7:9);
    b0 = vn0(1); w = 2*pi*f;
    eth = earth(pos0);
    tl = eth.tl; wN = eth.wnie(2); g = -eth.gn(3);
    RNh = eth.RNh; clRNh = eth.clRNh;
    t = (0:ts:T)'; t2 = t.*t; t3 = t2.*t; swt = sin(w*t); cwt = cos(w*t);
    vE = b0 + b1*t + a*swt;   % east-west velocity
    wy = (wN+b0/RNh)*t + b1/(2*RNh)*t2 - a/(w*RNh)*cwt;  % omega^n_N
    wz = tl*wy;
    fccz = -(2*wN*b0+(b0^2+a^2/2)/RNh)*t - (wN+b0/RNh)*b1*t2 -...
        b1^2/(3*RNh)*t3 - 2*b1*a/(w^2*RNh)*swt + 2*(wN+b0/RNh)*a/w*cwt + ...
        2*b1*a/(w*RNh)*t.*cwt + a^2/(4*w*RNh)*sin(2*w*t);
    fccy = -tl*fccz;
    imu = [t*0, wy, wz, vE, fccy, g*t+fccz];  % total increments
    imu = [diff(imu), t(2:end)]; % increments in interval 'ts'
    Cbn = a2mat(att0)';
    imu(:,1:6) = [Cbn*imu(:,1:3)'; Cbn*imu(:,4:6)']'; % n->b0 frame
    att = repmat(att0', length(t)-1, 1); % constant Euler angles
    vn = [vE(2:end), t(2:end)*0, t(2:end)*0]; % velocity, VN=VU=0
    pos = repmat(pos0', length(t)-1, 1); % position, lat=constant,hgt=constant
    pos(:,2) = pos(:,2) + b0/clRNh*t(2:end) + b1/(2*clRNh)*t2(2:end) - ...
        a/(w*clRNh)*(cwt(2:end)-1); % longitude
    avp = [att, vn, pos, t(2:end)];
    trj = varpack(imu, avp, avp0, ts);
