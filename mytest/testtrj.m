% Trajectory generation for later simulation use.
% See also  test_SINS, test_SINS_GPS_153, test_DR.
% profile on
clear all
glvs
ts = 0.01;       % sampling interval
avp0 = avpset([0;0;0], 0, glv.pos0); % init avp
% trajectory segment setting
xxx = [];
seg = trjsegment(xxx, 'init',         0);
seg = trjsegment(seg, 'uniform',      40);
seg = trjsegment(seg, 'turnleft',   10, 7);
seg = trjsegment(seg, 'accelerate',   10, xxx, 0.2);
seg = trjsegment(seg, 'uniform',      80);
seg = trjsegment(seg, 'turnright',   30, 4);
seg = trjsegment(seg, 'uniform',     30);
seg = trjsegment(seg, 'deaccelerate', 10,  xxx, 0.2);
seg = trjsegment(seg, 'uniform',      30);
% generate, save & plot
trj = trjsimu(avp0, seg.wat, ts, 1);
trjfile('trj10ms.mat', trj);
insplot(trj.avp);
imuplot(trj.imu);
% pos2gpx('trj_SINS_gps', trj.avp(1:round(1/trj.ts):end,7:9)); % to Google Earth
% profile viewer
