function imuplot(imu, type)
% SIMU data plot.
%
% Prototype: imuplot(imu, type)
% Inputs: imu - SIMU data, the last column is time tag
%         type - figure type
%          
% See also  imumeanplot, insplot, inserrplot, kfplot, gpsplot.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 27/08/2013, 09/02/2014, 03/10/2014
global glv
    dps = glv.dps; g0 = 9.8069; glv.g0;
    if nargin<2, type=0; end
    if size(imu,2)<7, imu(:,7) = (1:length(imu))'; end
    t = imu(:,7);
    if norm(mean(imu(:,4:6)))<9.8/2   % if it's velocity increment
        imu(:,1:6)=imu(:,1:6)/(t(2)-t(1));
    end
    myfigure,
    if type==1
        subplot(121), plot(t, [imu(:,1:3)]/dps); xygo('w');
        subplot(122), plot(t, [imu(:,4:6)]/g0);  xygo('f');
%         subplot(121), plot(t, [imu(:,1:3),normv(imu(:,1:3))]/dps); xygo('w'); legend('Wx','Wy','Wz','|W|');
%         subplot(122), plot(t, [imu(:,4:6),normv(imu(:,4:6))]/g0);  xygo('f'); legend('Ax','Ay','Az','|A|');
    elseif type==2
        ax = plotyy(t, imu(:,1:3)/dps, t, imu(:,4:6)/g0); xyygo(ax, 'w', 'f');
    elseif type==3
        subplot(311), ax = plotyy(t, imu(:,1)/dps, t, imu(:,4)/g0); xyygo(ax, 'wx', 'fx');
        subplot(312), ax = plotyy(t, imu(:,2)/dps, t, imu(:,5)/g0); xyygo(ax, 'wy', 'fy');
        subplot(313), ax = plotyy(t, imu(:,3)/dps, t, imu(:,6)/g0); xyygo(ax, 'wz', 'fz');
    elseif type==4
        wfdot = diff([imu(1,:);imu])/(t(2)-t(1));
        subplot(321), plot(t, [imu(:,1),wfdot(:,1)]/dps); xygo('wx');
        subplot(323), plot(t, [imu(:,2),wfdot(:,2)]/dps); xygo('wy');
        subplot(325), plot(t, [imu(:,3),wfdot(:,3)]/dps); xygo('wz');
        subplot(322), plot(t, [imu(:,4),wfdot(:,4)]/g0);  xygo('fx');
        subplot(324), plot(t, [imu(:,5),wfdot(:,5)]/g0);  xygo('fy');
        subplot(326), plot(t, [imu(:,6),wfdot(:,6)]/g0);  xygo('fz');
    elseif type==5
        wfdot = diff([imu(1,:);imu])/(t(2)-t(1));
        wfddot = diff([wfdot(1,:);wfdot])/(t(2)-t(1));
        subplot(321), plot(t, [imu(:,1),wfdot(:,1),wfddot(:,1)]/dps); xygo('wx');
        subplot(323), plot(t, [imu(:,2),wfdot(:,2),wfddot(:,2)]/dps); xygo('wy');
        subplot(325), plot(t, [imu(:,3),wfdot(:,3),wfddot(:,3)]/dps); xygo('wz');
        subplot(322), plot(t, [imu(:,4),wfdot(:,4),wfddot(:,4)]/g0);  xygo('fx');
        subplot(324), plot(t, [imu(:,5),wfdot(:,5),wfddot(:,5)]/g0);  xygo('fy');
        subplot(326), plot(t, [imu(:,6),wfdot(:,6),wfddot(:,6)]/g0);  xygo('fz');
    else
        lost = abs(diff(t))>mean(diff(t))*1.5;
        subplot(321), plot(t, imu(:,1)/dps, t(lost),imu(lost,1)/dps,'ro'); xygo('wx');
        subplot(323), plot(t, imu(:,2)/dps, t(lost),imu(lost,2)/dps,'ro'); xygo('wy');
        subplot(325), plot(t, imu(:,3)/dps, t(lost),imu(lost,3)/dps,'ro'); xygo('wz');
        subplot(322), plot(t, imu(:,4)/g0, t(lost),imu(lost,4)/g0,'ro');  xygo('fx');
        subplot(324), plot(t, imu(:,5)/g0, t(lost),imu(lost,5)/g0,'ro');  xygo('fy');
        subplot(326), plot(t, imu(:,6)/g0, t(lost),imu(lost,6)/g0,'ro');  xygo('fz');
    end

