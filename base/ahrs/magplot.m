function [yaw, incl] = magplot(mag)
% 3-axis geomagnetic plot.
%
% Prototype: magplot(mag)
% Input: mag - 3-axis geomagnetic in milli-Gauss
% Outputs: yaw - geomagnetic yaw with pitch=roll=0
%          incl - geomagnetic inclation with the asumpt. of device pitch=roll=0
%          
% See also  magyaw, imuplot, insplot, inserrplot, kfplot, gpsplot.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 17/03/2017
    if size(mag,2)<4, t = (1:size(mag,1))';
    else              t = mag(:,4);   end
    yaw = atan2(mag(:,1), mag(:,2));
    incl = atan2(mag(:,3), normv(mag(:,1:2)));
    myfigure;
    subplot(211), plot(t, [mag(:,1:3),normv(mag(:,1:3))]), xygo('\itt / \rms', 'Mag / mGauss');
    subplot(212), plot(t, [yaw,incl]/(pi/180)), xygo('\itt / \rms', 'MagYaw&Incl / \circ');