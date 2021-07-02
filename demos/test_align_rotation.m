% One-axis-rotation alignment simulation.
% Copyright(c) 2009-2019, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 20/09/2019
glvs
ts = 1/100;
% trj simu
att0 = [1;0;10]*glv.deg;
pos0 = posset(34, 116, 480);
att = attrottt(att0, [1, 0,0,1, 3000*glv.deg, 300,0,0], 0.01);
len = length(att);
avp = [att(:,1:3),zeros(len,3),repmat(pos0',len,1),att(:,4)];
imu = avp2imu(avp);
imuplot(imu);
% align
imuerr = imuerrset(0.01, 100, 0.0001, 1.0);
imu1 = imuadderr(imu,imuerr);
phi = [.1;.1;.5]*glv.deg;  att0 = q2att(qaddphi(a2qua(att0),phi));
wvn = [0.01;0.01;0.01];
[att00, attk] = alignvn(imu1, att0, pos0, phi, imuerr, wvn);
% error compare
avpcmpplot(attk, avp(:,[1:3,end]), 'phi');
