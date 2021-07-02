% SINS/GPS intergrated navigation simulation unsing kalman filter, with
% 18-state included:
%       phi(3), dvn(3), dpos(3), eb(3), db(3), lever(3)
% Please run 'test_SINS_trj.m' to generate 'trj10ms.mat' beforehand!!!
% See also  test_SINS_GPS.
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 08/08/2014
glvs
psinstypedef(186);
trj = trjfile('trj10ms.mat');
[nn, ts, nts] = nnts(2, trj.ts);
%% init
imuerr = imuerrset(0.03, 100, 0.001, 10);
imu = imuadderr(trj.imu, imuerr);
davp0 = avpseterr([30;-30;30], [0.1;0.1;0.1], [1;1;3]);
lever = [1; 2; 3];
gps = gpssimu(trj.avp, davp0(4:6), davp0(7:9), 1, lever);
imugpssyn(imu(:,7), gps(:,7));
ins = insinit(trj.avp0(1:9), ts, davp0); ins.nts=nts;
%% kf
r0 = [[1;1;1]*0.1; posseterr([1; 1; 1])];
kf = kfinit(ins, davp0, imuerr, lever, r0);
len = length(imu); [avp, xkpk] = prealloc(fix(len/nn), 10, 2*kf.n+1);
timebar(nn, len, '18-state SINS/GPS simulation.'); ki = 1;
for k=1:nn:len-nn+1
    k1 = k+nn-1; 
    wvm = imu(k:k1,1:6); t = imu(k1,end);
    ins = insupdate(ins, wvm);
    kf.Phikk_1 = kffk(ins);
    kf = kfupdate(kf);
    [kgps, dt] = imugpssyn(k, k1, 'F');
    if kgps>0
        vnGPS = gps(kgps,1:3)'; posGPS = gps(kgps,4:6)';
        ins = inslever(ins);
        kf.Hk = kfhk(ins);
        zk = [ins.vnL-ins.an*dt-vnGPS; ins.posL-ins.Mpvvn*dt-posGPS];
        kf = kfupdate(kf, zk, 'M');
        [kf, ins] = kffeedback(kf, ins, 1, 'V');
        avp(ki,:) = [ins.avp', t];
        xkpk(ki,:) = [kf.xk; diag(kf.Pxk); t]';  ki = ki+1;
    end
    timebar;
end
avp(ki:end,:) = []; xkpk(ki:end,:) = [];
avperr = avpcmp(avp, trj.avp);
insplot(avp);
kfplot(xkpk, avperr, imuerr, lever);

