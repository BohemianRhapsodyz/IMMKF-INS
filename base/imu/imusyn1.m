function [imu1, imurem] = imusyn1(imu0, ts, tau, imurem)
% Time-asychronization compensation between IMU sensors.
%
% Prototype: imu = imusyn(imu, tdr)
% Inputs: imu - IMU rawdata
%         tdr - time delay ratio = time delay/sampling interval, always 0<=tdr<=1.
% Output: imu - IMU output
%
% See also: imuadderr, imugpsyn.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 08/10/2014
    if nargin<4, imurem=zeros(1,6); end
    tau = tau(1:6)'; imurem = imurem(:)';
    n = size(imu0,1);
    imu1 = imu0;
    afa = ts./(ts+tau);
    for k=1:n
        imuk = imu0(k,1:6)+imurem;
        imu1(k,1:6) = imuk.*afa;
        imurem = imuk-imu1(k,1:6);
    end
