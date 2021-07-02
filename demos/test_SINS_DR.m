% SINS/DR integrated navigation simulation.
% Please run 'test_SINS_trj.m' to generate 'trj10ms.mat' beforehand!!!
% See also  test_SINS_trj, test_DR.
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 24/02/2012, 08/04/2014
glvs
psinstypedef('test_SINS_DR_def');
trj = trjfile('trj10ms.mat');
[nn, ts, nts] = nnts(2, trj.ts);
inst = [3;60;6];  kod = 1;  qe = 0; dT = 0.01; % od parameters
trjod = odsimu(trj, inst, kod, qe, dT, 0); % od simulation
imuerr = imuerrset(0.01, 50, 0.001, 5);
imu = imuadderr(trjod.imu, imuerr);
davp = avpseterr([30;30;10], 0, 10);
ins = insinit(avpadderr(trjod.avp0,davp), ts); % SINS init
dinst = [15;0;10]; dkod = 0.01;
dr = drinit(avpadderr(trjod.avp0,davp), d2r((inst+dinst)/60), kod*(1+dkod), ts); % DR init
kf = kfinit(nts, davp, imuerr, dinst, dkod, dT); % kf init
len = length(imu); 
[dravp, insavp, xkpk] = prealloc(fix(len/nn), 10, 10, 2*kf.n+1);
ki = timebar(nn, len, 'SINS/DR simulation.');
for k=1:nn:len-nn+1
    k1 = k+nn-1;
    wvm = imu(k:k1,1:6);  dS = sum(trjod.od(k:k1,1)); t = imu(k1,end);
    ins = insupdate(ins, wvm);
    dr.qnb = ins.qnb;   % DR quaternion setting !
    dr = drupdate(dr, wvm(:,1:3), dS);
    kf.Phikk_1 = kffk(ins);
    kf = kfupdate(kf);
    if mod(k1,10)==0
        kf.Hk(:,22) = -ins.Mpvvn;
        kf = kfupdate(kf, ins.pos-dr.pos);
        [kf, ins] = kffeedback(kf, ins, 1, 'v');
    end
    insavp(ki,:) = [ins.avp; t]';
    dravp(ki,:) = [dr.avp; t]';
    xkpk(ki,:) = [kf.xk; diag(kf.Pxk); t]';
    ki = timebar;
end
dr.distance,
insplot(dravp, 'DR', insavp);
kfplot(xkpk, trjod.avp, insavp, dravp, imuerr, dinst, dkod, dT);
