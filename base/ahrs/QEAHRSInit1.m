function ahrs = QEAHRSInit1(ts)
% Quaternion&EKF based AHRS algorithm with state vector
% X=[q0,q1,q2,q3,ebx,eby,ebz]' : q*-quaternion element, eb*-gyro drift.
%
% Prototype: ahrs = QEAHRSInit(ts)
% Inputs: ts - AHRS update interval
% Output: ahrs - output AHRS structure array
%
% See also  QEAHRSUpdate, MahonyInit.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 07/06/2017
global glv
    kf.Qt = diag([[10;10;10;10]*glv.dpsh; [10;10;10]*glv.dphpsh])^2;
    kf.Pxk = diag([[1;1;1;1]; [1000;1000;1000]*glv.dph])^2;
    kf.Pmax = [[1;1;1;1]; [1000;1000;1000]*glv.dph].^2;
    kf.Pmin = [[1;1;1;1]*0.001; [1;1;1]*glv.dph].^2;
    kf.pconstrain = 1;
    kf.Rk = diag([[10;10]*glv.mg; [10;10]])^2;
    kf.Phikk_1 = eye(7);
    kf.Hk = zeros(4,7);
    kf.xk = [1;0;0;0; 0;0;0];
    kf = kfinit0(kf, ts);
    ahrs.Cnb = q2mat(kf.xk(1:4));
    ahrs.kf = kf;
    ahrs.tk = 0;

