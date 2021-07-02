% Tranfer align simulation. Kalman filter states include:
% [phi, dvn, eb, db, mu, theta, omega]', but lever arm between
% SINS and MINS no considered.
% Please run 'test_align_transfer_trj.m' &
%            'test_align_transfer_imu_simu.m' beforehand!!!
% See also  test_align_transfer_trj, test_align_transfer_imu_simu.
%           test_align_methods_compare.
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 02/06/2011
glvs
psinstypedef('test_align_transfer_def');
load([glv.datapath,'trj_transfer.mat']);
load([glv.datapath,'imu_transfer.mat']);
ts = trj.ts;
qnbs = a2qua(trj.avp0(1:3)); vns = trj.avp0(4:6); % slave INS init
kf = kfinit(ts, imuerr, beta, Q);
len = length(trj.imu); [res, xkpk] = prealloc(len, 7, 2*kf.n+1);
timebar(1, len, 'Transfer alignment simulaton.');
for k=1:len
    [phim, dvbm] = cnscl(imu(k,:)); t = imu(k,7);
    qnbm = a2qua(trj.avp(k,1:3)');  vnm = trj.avp(k,4:6)'; posm = trj.avp(k,7:9)'; % master INS
    eth = earth(posm, vnm);
    Cnbs = q2mat(qnbs);
    dvn = Cnbs*dvbm; vns = vns + dvn + eth.gcc*ts;    % slave INS velocity
    qnbs = qupdt(qnbs, phim-Cnbs'*eth.wnin*ts);  % slave INS attitude
    kf.Phikk_1(1:6,1:3) = [-askew(eth.wnin*ts)+glv.I33; askew(dvn)];
        kf.Phikk_1(1:3,7:9) = -Cnbs*ts; kf.Phikk_1(4:6,10:12) = Cnbs*ts;
    kf.Hk(1:3,13:18) = [-Cnbs,-Cnbs];
    kf = kfupdate(kf, [qq2phi(qnbs,qnbm); vns-vnm]);
    res(k,:) = [qq2phi(qnbs,qnbsk(k,:)'); vns-vnm; t]'; 
    xkpk(k,:) = [kf.xk; diag(kf.Pxk); t]';
    timebar;
end
kfplot(xkpk, res, imuerr, mub, thetak, omegak);
