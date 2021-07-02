% Trajectory simulation for POS.
% See also  test_POS_fusion.
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 10/02/2014
glvs
ts = 0.1;
avp0 = avpset([0;0;0], 0, glv.pos0);
xxx = [];
seg = trjsegment(xxx, 'init',         0);
seg = trjsegment(seg, 'uniform',      100);
seg = trjsegment(seg, 'accelerate',   20, xxx, 5);
seg = trjsegment(seg, 'uniform',      10);
seg = trjsegment(seg, 'climb',        15, 2, xxx, 20);
seg = trjsegment(seg, 'uniform',      50);
seg = trjsegment(seg, '8turn',        360, 2, xxx, 4);
seg = trjsegment(seg, 'uniform',      50);
seg = trjsegment(seg, 'coturnleft',   45, 2, xxx, 4);
for k=1:2
seg = trjsegment(seg, 'uniform',      380);
seg = trjsegment(seg, 'coturnright',  90, 2, xxx, 4);
seg = trjsegment(seg, 'uniform',      380);
seg = trjsegment(seg, 'coturnleft',   90, 2, xxx, 4);
end
seg = trjsegment(seg, 'coturnleft',   45, 2, xxx, 4);
seg = trjsegment(seg, 'uniform',      550);
seg = trjsegment(seg, 'coturnleft',   105, 180/105, xxx, 4);
seg = trjsegment(seg, 'uniform',      50);
seg = trjsegment(seg, 'descent',      15, 2, xxx, 20);
seg = trjsegment(seg, 'uniform',      30);
seg = trjsegment(seg, 'deaccelerate', 20, xxx, 5);
seg = trjsegment(seg, 'uniform',      3600-sum(seg.wat(:,1)));
trj = trjsimu(avp0, seg.wat, ts, 1);
trjfile('trjPOS10ms.mat', trj);  % save
insplot(trj.avp);
imuplot(trj.imu);

