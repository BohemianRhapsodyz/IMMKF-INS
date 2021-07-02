% POS and data fusion simulation. A 37-state Kalman filter is used, 
% including: phi(3), dvn(3), dpos(3), eb(3), db(3), lever(3), dT(1), 
%            dKg(9), dKa(6), dvnGPS(3). (total states 6*3+1+9+6+3=37)
% Please run 'test_POS_trj.m' to generate 'trjPOS10ms.mat' beforehand!!!
% See also  test_POS_trj.
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 10/02/2014, 10/03/2015
glvs
psinstypedef(376);
%% init
trj = trjfile('trjPOS10ms.mat');
davp0 = avpseterr([30;-30;30], [0.01;0.01;0.03], [0.01;0.01;0.03]);
lever = [0.5; 1.5; 2]; dT = 0.009; r0 = davp0(4:9)';
gps = gpssimu(trj.avp, davp0(4:6), davp0(7:9), 3, lever, dT, 1); gps(:,1:3) = gps(:,1:3)+0.1;
[nn, ts, nts] = nnts(4, trj.ts);
imuerr = imuerrset([1;2;3]*0.01, [50;100;150], 0.001, 10, 0,0,0,0, 20,10);
imu = imuadderr(trj.imu, imuerr);
ins = insinit(avpadderr(trj.avp0(1:9),davp0), ts); ins = inslever(ins);  ins.nts = nts;
kf = kfinit(ins, davp0, imuerr, lever, dT, r0);
%% POS, forward & backward processing
ps = POSProcessing(kf, ins, imu(1:end,:), gps, 'avped', 'avp');
avperr = avpcmp(ps.avp(:,[1:9,end]), trj.avp);
iavperr = avpcmp(ps.iavp(:,[1:9,end]), trj.avp);
% insplot(ps.avp, 'avp');  insplot(ps.iavp, 'avp');
% kfplot(ps.xkpk, avperr, imuerr, lever, dT);
% kfplot(ps.ixkpk, iavperr, imuerr, lever, dT);
%% fusion
psf = POSFusion(ps.avp, ps.xkpk, ps.iavp, ps.ixkpk);
err = [imuerr.eb;imuerr.db;lever;dT;imuerr.dKga;[0;0;0]]'*0;
psf.xf = avpcmp(psf.rf, trj.avp, err);
psf.x1 = avpcmp(psf.r1, trj.avp, err);
psf.x2 = avpcmp(psf.r2, trj.avp, err);
POSplot(psf);
