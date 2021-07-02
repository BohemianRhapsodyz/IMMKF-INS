% Random Walk Simulation
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 16/07/2011
glvs
ts = 0.1;
t = 1*3600;
len = fix(t/ts);
imuerr = imuerrset(0, 0, 0.01, 10);
imu = imuadderr(zeros(len,6), imuerr, ts);
imu = cumsum(imu, 1);  % accumulate
myfigure;
tt = (1:len)'*ts; 
gg = imuerr.web(1)*sqrt(tt); aa = imuerr.wdb(1)*sqrt(tt);  % reference values
subplot(211), plot(tt,imu(:,1:3)/glv.deg, tt,gg/glv.deg,'m--', tt,-gg/glv.deg,'m-.')
title('Angular Random Walk'); xygo('\Delta\it\theta\rm / \circ');
legend('X', 'Y', 'Z', '1\sigma upper bound', '1\sigma lower bound')
subplot(212), plot(tt,imu(:,4:6), tt,aa,'m--', tt,-aa,'m-.')
title('Velocity Random Walk'); xygo('\Delta\itV\rm / m/s');
legend('X', 'Y', 'Z', '1\sigma upper bound', '1\sigma lower bound')
