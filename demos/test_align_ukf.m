% Unscented Kalman filter(UKF) simulation with large misalignment angles.
% See also  test_align_some_methods, test_align_ekf.
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 05/09/2013
clear all
glvs;
psinstypedef('test_align_ukf_def');
[nn, ts, nts] = nnts(4, 0.1);
T = 600;
avp0 = avpset([10;0;-180], [0;0;0], [34;108;380]); qnb0 = a2qua(avp0(1:3)');
imuerr = imuerrset(0.01, 50, 0.001, 5);
[imu, eth] = imustatic(avp0, ts, T, imuerr);   % imu simulation
afa = [-5; 7; 80]*glv.deg;  % large misalignment angles
qpb = qaddafa(qnb0,afa);  vn = zeros(3,1);
kf = kfinit(nts, imuerr); kf.s = 1.01; % forgetting factor
len = length(imu); [res, xkpk] = prealloc(fix(len/nn), 6, 2*kf.n+1);
ki = timebar(nn, len, 'UKF align simulation.');
for k=1:nn:len-nn+1
    k1 = k+nn-1;
    wvm = imu(k:k1,1:6);  t = imu(k1,7);
    [phim, dvbm] = cnscl(wvm);
    dvn = qmulv(qpb,dvbm); vn = vn + dvn + eth.gn*nts;
    qpb = qupdt(qpb, phim-qmulv(qconj(qpb),eth.wnie*nts));
    res(ki,:) = [qq2afa(qpb, qnb0); vn]';
    kf.px = [eth.wnie; dvn/nts; nts];
    kf = ukf(kf, vn);  % UKF filter
    xkpk(ki,:) = [kf.xk; diag(kf.Pxk); t]';
    ki = timebar;
end
kfplot(xkpk, res);
