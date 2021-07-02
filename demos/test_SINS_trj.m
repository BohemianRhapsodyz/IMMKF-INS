% Trajectory generation for later simulation use.
% See also  test_SINS, test_SINS_GPS_153, test_DR.
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 10/06/2011, 10/02/2014
% profile on
clear all
glvs
ts = 0.01;       % sampling interval
avp0 = avpset([0;0;0], 0, glv.pos0); % init avp
% trajectory segment setting
xxx = [];
seg = trjsegment(xxx, 'init',         0);
seg = trjsegment(seg, 'uniform',      100);
seg = trjsegment(seg, 'accelerate',   10, xxx, 1);
seg = trjsegment(seg, 'uniform',      100);
seg = trjsegment(seg, 'coturnleft',   45, 2, xxx, 4);
seg = trjsegment(seg, 'uniform',      100);
seg = trjsegment(seg, 'coturnright',  10*5, 9, xxx, 4);
seg = trjsegment(seg, 'uniform',      100);
seg = trjsegment(seg, 'climb',        10, 2, xxx, 50);
seg = trjsegment(seg, 'uniform',      100);
seg = trjsegment(seg, 'descent',      10, 2, xxx, 50);
seg = trjsegment(seg, 'uniform',      100);
seg = trjsegment(seg, 'deaccelerate', 5,  xxx, 2);
seg = trjsegment(seg, 'uniform',      100);
% generate, save & plot
trj = trjsimu(avp0, seg.wat, ts, 1);
trjfile('trj10ms.mat', trj);
insplot(trj.avp);
imuplot(trj.imu);
% pos2gpx('trj_SINS_gps', trj.avp(1:round(1/trj.ts):end,7:9)); % to Google Earth
% profile viewer
