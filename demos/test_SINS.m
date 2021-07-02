% SINS pure inertial navigation simulation. Please run 
% 'test_SINS_trj.m' to generate 'trj10ms.mat' beforehand!!!
% See also  test_SINS_trj, test_SINS_GPS_153, test_SINS_static.
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 17/06/2011
profile on
glvs
trj = trjfile('trj10ms.mat');
[nn, ts, nts] = nnts(4, trj.ts);
imuerr = imuerrset(0.01, 100, 0.001, 10);
imu = imuadderr(trj.imu, imuerr);
davp0 = avpseterr([30;30;10], 0.1, [10;10;10]);
avp00 = avpadderr(trj.avp0, davp0);
trj = bhsimu(trj, 1, 10, 3, ts);
avp = inspure(imu, avp00, trj.bh);  % pure inertial navigation
avperr = avpcmp(avp, trj.avp);
inserrplot(avperr)
profile viewer
