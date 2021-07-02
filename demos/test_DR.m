% Dead Recoding simulation.
% Please run 'test_SINS_trj.m' to generate 'trj10ms.mat' beforehand!!!
% See also  test_SINS_trj, test_SINS_DR.
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 24/02/2012, 08/04/2014
glvs
trj = trjfile('trj10ms.mat');
[nn, ts, nts] = nnts(2, trj.ts);
inst = [3;60;10];  kod = 1;  qe = 0; dT = 0;  % od parameters
trjod = odsimu(trj, inst, kod, qe, dT, 0);
imuerr = imuerrset(0.01, 50, 0.001, 5);
imu = imuadderr(trjod.imu, imuerr);
davp = avpseterr([3600;0;60], 0, 0);
dinst = [15;0;10]*0; dkod = 0.05;
dr = drinit(avpadderr(trjod.avp0,davp), inst+dinst, kod*(1+dkod), ts); % DR init
len = length(imu); avp = prealloc(fix(len/nn), 10);
ki = timebar(nn, len, 'DR simulation.');
for k=1:nn:len-nn+1
    k1 = k+nn-1;
    wm = imu(k:k1,1:3);  dS = sum(trjod.od(k:k1,1)); t = imu(k1,end);
    dr = drupdate(dr, wm, dS); 
    avp(ki,:) = [dr.avp; t]';
    ki = timebar;
end
dr.distance,
avperr = avpcmp(avp, trjod.avp);
insplot(avp, 'DR', trj.avp);
inserrplot(avperr);
