% Several popular align methods are compared using real data. The laser 
% gyro SIMU data is sampled on vehicle with some disturbance.
% See also  test_align_methods_compare, test_align_ekf, test_align_ukf.
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 10/03/2014
glvs
[imu, avp0, ts] = imufile('lasergyro');
idx = (1/ts:300/ts)';
%% i0 method
[atti0, resi0] = aligni0(imu(idx,:), avp0(7:9), ts);
% resfit = aligni0fit(resi0, resi0.lat, resi0.nts);
%% i0 & Wahba method
[att0w, attkw] = alignWahba(imu(idx,:), avp0(7:9), ts);
%% coarse align
[attsb, qnb] = alignsb(imu(idx,:), avp0(7:9));
%% fn-meas. Kalman filter
att0 = [0;0;-92]*glv.deg;
phi = [.5;.5;5]*glv.deg;
imuerr = imuerrset(0.03, 100, 0.001, 10);
[att0f, attkf, xkpkf] = alignfn(imu(idx,:), att0, avp0(7:9), phi, imuerr, ts);
%% vn-meas. Kalman filter
att0 = [0;0;-92]*glv.deg;
phi = [.5;.5;5]*glv.deg;
imuerr = imuerrset(0.03, 100, 0.001, 10);
wvn = [0.1;0.1;0.1];
[att0v, attkv, xkpkv] = alignvn(imu(idx,:), att0, avp0(7:9), phi, imuerr, wvn, ts);
%% gyro-compass method
att0 = [0;0;-92]*glv.deg;
ctl0 = [20; 30]; ctl1 = [50; 150];
[att0c, attkc] = aligncmps(imu(idx,:), att0, avp0(7:9), ctl0, ctl1, ts);
%% compare & show different methods
[phii0p,phii0v,phii0w,phikf,phic] = setvals(zeros(size(attkc)));
phii0p = aa2phi(resi0.attk,attkv);
phii0v = aa2phi(resi0.attkv,attkv);
phii0w = aa2phi(attkw,attkv);
phikf = aa2phi(attkf,attkv);
phic = aa2phi(attkc,attkv);
myfigure,
t = (1:length(attkv))'*resi0.nts;
subplot(211);  xygo('phiE')
plot(t, [phii0p(:,1),phii0v(:,1),phii0w(:,1),phikf(:,1),phic(:,1)]/glv.sec)
legend('i0 pos', 'i0 vel', 'i0 Whaba', 'Kalman fn', 'gyro-compass');
subplot(212);  xygo('phiN')
plot(t, [phii0p(:,2),phii0v(:,2),phii0w(:,2),phikf(:,2),phic(:,2)]/glv.sec)
legend('i0 pos', 'i0 vel', 'i0 Whaba', 'Kalman fn', 'gyro-compass');
myfigure;  xygo('phiU')
plot(t, [phii0p(:,3),phii0v(:,3),phii0w(:,3),phikf(:,3),phic(:,3)]/glv.min)
legend('i0 pos', 'i0 vel', 'i0 Whaba', 'Kalman fn', 'gyro-compass');
myfigure, xygo('pr')
plot(t, [resi0.attk(:,1),resi0.attkv(:,1),attkw(:,1),attkf(:,1),attkv(:,1),attkc(:,1)]/glv.deg)
plot(t, [resi0.attk(:,2),resi0.attkv(:,2),attkw(:,2),attkf(:,2),attkv(:,2),attkc(:,2)]/glv.deg)
legend('i0 pos', 'i0 vel', 'i0 Whaba', 'Kalman fn', 'Kalman vn', 'gyro-compass');
myfigure, xygo('y')
plot(t, [resi0.attk(:,3),resi0.attkv(:,3),attkw(:,3),attkf(:,3),attkv(:,3),attkc(:,3)]/glv.deg)
legend('i0 pos', 'i0 vel', 'i0 Whaba', 'Kalman fn', 'Kalman vn', 'gyro-compass');
