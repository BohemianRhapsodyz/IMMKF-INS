% SINS updating using Runge-Kutta method compared with 2-sample alogrithm.
% Please run 'test_SINS_trj.m' to generate 'trj10ms.mat' beforehand!!!
% See also  test_SINS.
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 05/05/2014
glvs
trj = trjfile('trj10ms.mat');
[nn, ts, nts] = nnts(2, trj.ts);
imuerr = imuerrset(0.01, 100, 0.001, 10);
imu = imuadderr(trj.imu, imuerr);
davp0 = avpseterr([30;30;10], 0.1, [10;10;10]);
avp00 = avpadderr(trj.avp0, davp0);
ins = insinit(avp00, ts);
avp_rk4 = avp00;
len = length(imu); [avp, avp4] = prealloc(fix(len/nn)-1, 10, 10);
ki = timebar(nn, len, 'SINS Runge-Kutta Simulation.');
for k=1:nn:len-nn+1-1
    k1 = k+nn-1;  
    wvm = imu(k:k1,1:6);  t = imu(k1,end);
    ins = insupdate(ins, wvm);  ins.pos(3) = trj.avp(k1,9);
    wf = imu(k:k1+1,1:6)'/ts;
    avp_rk4 = rgkt4(@dsins, wf, avp_rk4, nts);  avp_rk4(9) = trj.avp(k1,9);
    avp(ki,:) = [ins.avp; t]';
    avp4(ki,:) = [avp_rk4; t]';
    ki = timebar; 
end
avperr = avpcmp(avp, trj.avp);
insplot(avp);
inserrplot(avperr)
avperr4 = avpcmp(avp4, trj.avp);
subplot(221), plot(avp4(:,10), avperr4(:,1:2)/glv.sec, 'm');
subplot(222), plot(avp4(:,10), avperr4(:,3)/glv.min, 'm');
subplot(223), plot(avp4(:,10), avperr4(:,4:6), 'm');
subplot(224), plot(avp4(:,10), avperr4(:,7:8)*glv.Re, 'm');

