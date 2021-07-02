% Trajector simulation for tranfer align.
% See also  test_align_transfer_imu_simu, test_align_transfer.
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 02/06/2011
clear all
glvs
ts = 0.01;
vel0 = 180;
avp0 = avpset([0;0;-30], vel0, [34;108;380+1000]);
roll_f = 0.5;  % roll frequency
t = (0:ts:0.5/roll_f)';
roll = 20*glv.deg * [cos(2*pi*roll_f*t)-1; 
    -2*cos(2*pi*roll_f*t); 
    cos(2*pi*roll_f*t)+1] * 0.5;  % roll angle sequence
wy = diff(roll)/ts;
wt = [zeros(10/ts,3);       % uniform
    zeros(length(wy),1), wy, zeros(length(wy),1); % swaying
    zeros(10/ts,3) ];       % uniform
at = zeros(size(wt));
wat = [zeros(length(wt),2), wt, at];  
wat(:,1) = ts; wat(:,2) = vel0;
trj = trjsimu(avp0, wat, ts, 2);
save([glv.datapath,'trj_transfer.mat'], 'trj');
insplot(trj.avp);
imuplot(trj.imu);
