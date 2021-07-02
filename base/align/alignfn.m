function [att0, attk, xkpk] = alignfn(imu, qnb, pos, phi0, imuerr, ts)
% SINS initial align uses Kalman filter with fn as measurement.
% Kalman filter states: [phiE, phiN, phiU, eby, ebz]'.
%
% Prototype: [att0, attk, xkpk] = alignfn(imu, qnb, pos, phi0, imuerr, ts)
% Inputs: imu - IMU data
%         qnb - coarse attitude quaternion (or att)
%         pos - position
%         phi0 - initial misalignment angles estimation
%         imuerr - IMU error setting
%         ts - IMU sampling interval
% Output: att0 - attitude align result
%
% See also  alignvn, aligncmps, aligni0, alignWahba, alignsb.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 17/06/2011
global glv
    if nargin<6,  ts = imu(2,7)-imu(1,7);  end
    if length(qnb)==3, qnb=a2qua(qnb); end  %if input qnb is Eular angles.
    nn = 2; nts = nn*ts;
    len = fix(length(imu)/nn)*nn;
    eth = earth(pos);  Cnn = rv2m(-eth.wnie*nts/2);
    kf = afnkfinit(nts, pos, phi0, imuerr); 
    [attk, xkpk] = prealloc(fix(len/nn), 3, 2*kf.n);
    ki = timebar(nn, len, 'Initial align using fn as meas.');
    for k=1:nn:len-nn+1
        wvm = imu(k:k+nn-1, 1:6);
        [phim, dvbm] = cnscl(wvm);
        fn = Cnn*qmulv(qnb, dvbm/nts);
        qnb = qupdt(qnb, phim-qmulv(qconj(qnb),eth.wnie)*nts);  % att updating
        kf = kfupdate(kf, fn(1:2));
        qnb = qdelphi(qnb, 0.1*kf.xk(1:3)); kf.xk(1:3) = 0.9*kf.xk(1:3); % feedback
        attk(ki,:) = q2att(qnb)';
        xkpk(ki,:) = [kf.xk; diag(kf.Pxk)];
        ki = timebar;
    end
    attk(ki:end,:) = []; xkpk(ki:end,:) = [];
    att0 = attk(end,:)';
    resdisp('Initial align attitudes (arcdeg)', att0/glv.deg);
    afnplot(nts, attk, xkpk);

function kf = afnkfinit(nts, pos, phi0, imuerr)
    eth = earth(pos);
    kf = []; kf.s = 1; kf.nts = nts;
    kf.Qk = diag([imuerr.web; 0;0])^2*nts;
	kf.Rk = diag(imuerr.wdb(1:2)/sqrt(nts))^2;
	kf.Pxk = diag([phi0; imuerr.eb(1:2)])^2;
	wN = eth.wnie(2); wU = eth.wnie(3); g = -eth.gn(3);
	Ft = [  0   wU -wN   0   0 
           -wU  0   0   -1   0 
            wN  0   0    0  -1 
            zeros(2,5)          ];
    kf.Phikk_1 = eye(5)+Ft*nts;
    kf.Hk = [ 0  -g  0  0  0
              g   0  0  0  0 ];
    [kf.m, kf.n] = size(kf.Hk);
    kf.I = eye(kf.n);
    kf.xk = zeros(kf.n, 1);
    kf.adaptive = 0;
    kf.fading = 1;
    kf.Gammak = 1;
    kf.xconstrain = 0;
    kf.pconstrain = 0;

function afnplot(ts, attk, xkpk)
global glv
    t = (1:length(attk))'*ts;
    myfigure;
	subplot(321); plot(t, attk(:,1:2)/glv.deg); xygo('pr');
	subplot(323); plot(t, attk(:,3)/glv.deg); xygo('y');
	subplot(325), plot(t, xkpk(:,4:5)/glv.dph); xygo('ebyz');
	subplot(322); plot(t, sqrt(xkpk(:,6:7))/glv.min); xygo('phiEN');
	subplot(324); plot(t, sqrt(xkpk(:,8))/glv.min); xygo('phiU');
	subplot(326), plot(t, sqrt(xkpk(:,9:10))/glv.dph); xygo('ebyz');