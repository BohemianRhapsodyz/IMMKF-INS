function imu = imusyn(imu, tau, imu0)
% Time-asychronization compensation between IMU sensors.
%
% Prototype: imu = imusyn(imu, tau)
% Inputs: imu - IMU rawdata
%         tau - time delay parameters, tau<ts where ts is sampling interval
%         imu0 - IMU sample at time t0
% Output: imu - IMU output
%
% See also: imuadderr, imugpsyn.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 25/08/2014
    if nargin<3, imu0=2*imu(1,:)-imu(2,:); end
    ts = imu(2,end)-imu(1,end);
    if size(imu,2)<6&&length(tau)<6, N=3;  % gyro only
    else  N=6; end
    if size(imu,2)>=6&&length(tau)==1, tau=[0;0;0;tau;tau;tau]; N=6; end % acc triad delay
    for k = 1:N
        imu(:,k) = imu(:,k) - tau(k)/ts*diff([imu0(1,k);imu(:,k)]);
    end
