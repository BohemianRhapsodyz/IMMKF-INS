% Operate PSINS-defined format files for SIMU or GPS data.
% See also  imufile, avpfile.
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 10/03/2014
glvs
load([glv.datapath,'trj10ms.mat']);
imu = imuresample(trj.imu, 0.01);   imuplot(imu);
fname = 'trj_simu';
imufile(fname, imu, trj.avp0);
imu1 = imufile(fname);
imuplot(imu1);
avpfile(fname, trj.avp(100:100:end,:));
avp = avpfile(fname);
gpsplot(avp(:,4:end));
return
%% test for real SIMU data
ts = 0.008;   % sampling interval
imu = load('lgimu.dat');  % coase yaw angle is -90.6 deg
avp0 = avpset([0;0;-90.6], [0;0;0], glv.pos0);
imu = [imu(:,1:3)*0.932*glv.sec, imu(:,4:6)*500*glv.ug, (1:length(imu))'*ts];  % scale factors
imuplot(imu);
imu1 = imuresample(imu, 0.01);  imuplot(imu1);
imufile('lasergyro',imu1,avp0);
