% Several popular align methods are compared.
% See also  test_align_methods_compare_lgimu, test_align_ekf, test_align_ukf,
%           alignvn, aligni0, aligncmps.
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 10/03/2014
glvs
ts = 0.1;   % sampling interval
T = 1000;
avp0 = avpset([0;0;0], [0;0;0], [30;108;380]);
imuerr = imuerrset(0.01, 50, 0.0001, 0.10);
imu = imustatic(avp0, ts, T, imuerr);   % IMU simulation
davp = avpseterr([-30;30;30]*0, [0.01;0.01;0.01]*0, [1;1;1]*0);
avp = avpadderr(avp0, davp);
%% vn-meas. Kalman filter
phi = [.5;.5;.005]*glv.deg;
imuerr1 = imuerrset(0.03, 100, 0.001, 10);
wvn = [0.01;0.01;0.01];
[att0v, attkv, xkpkv] = alignvn(imu, avp(1:3), avp(7:9), phi, imuerr1, wvn);
