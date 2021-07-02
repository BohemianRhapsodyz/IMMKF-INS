function [wm, qt, wt, at] = highmansimu(pcoef, ts, T, iffig)
% High maneuver attitude simulation which is expressed as polynomial.
%
% Prototype: [wm, qt, wt] = highmansimu(pcoef, ts, T)
% Inputs: pcoef - 3xn angluar rate coefficients of the polynomial in 
%                 descending powers
%         ts - sampling interval
%         T - total simulation time
%         iffig - figure flag, 0 for no figure
% Outputs: wm = [      wm1,  wm2, ... , wmN ]';    % angular increment
%          qt = [ q0,  q1,   q2,  ... , qN  ]';    % quaternion reference
%          wt = [ w0,  w1,   w2,  ... , wN  ]';    % angular rate
%          at = [ a0,  a1,   a2,  ... , aN  ]';    % angular acceleration
%
% Example:
%     ts = 0.01; T = 2;
%     pcoef = [ -7.8125e-01     6.25e-01     2.8125e-01     2.5       0
%               -3.1250e-02    -5.50e-01     4.5000e-01    -5.0e-01   0
%                1.8750e-01    -6.75e-01     2.25          -2.55      0 ];
%     [wm, qt, wt, at] = highmansimu(pcoef, ts, T, 1);
    
% See also  conesimu, scullsimu, trjsimu, conecoef, conedrift.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 03/02/2017
    sz2 = size(pcoef,2);
    t = (-(sz2-1)*ts:ts:T)';
    wm = [ polyval(polyint(pcoef(1,:)),t), ...
           polyval(polyint(pcoef(2,:)),t), ...
           polyval(polyint(pcoef(3,:)),t) ];
    wm = wm(2:end,:) - wm(1:end-1,:);
    A1 = wm2wtcoef(ts, 1, sz2);
    qq = [1;0;0;0];  qt = zeros(length(wm)-sz2+1,4);
    for k=1:length(qt)
        qt0 = qpicard(wm(k:k+sz2-1,:)'*A1, ts, 1e-30);
        qq = qmul(qq, qt0); 
        qt(k,:) = qq';
    end
    wm(1:sz2-1,:) = []; t(1:sz2-1) = []; qt = [[1;0;0;0]'; qt];

    wt = [ polyval(pcoef(1,:),t), polyval(pcoef(2,:),t), polyval(pcoef(3,:),t) ];
    at = [ polyval(polyder(pcoef(1,:)),t), ...
           polyval(polyder(pcoef(2,:)),t), ...
           polyval(polyder(pcoef(3,:)),t) ];
    
    if ~exist('iffig', 'var'), iffig=0; end
    if iffig~=0
        figure
        deg = pi/180;
        subplot(211);
        AX = plotyy(t, wt/deg, t, at/deg); xygo('angular rate / \circ/s');
        legend('wx', 'wy', 'wz', 'ax', 'ay', 'az');
        set(get(AX(2),'Ylabel'),'String','angular acceleration / \circ/s^2');
        subplot(212);
        pitch = asin(2*(qt(:,3).*qt(:,4)+qt(:,1).*qt(:,2)));
        roll = atan2(-2*(qt(:,2).*qt(:,4)-qt(:,1).*qt(:,3)),qt(:,1).^2-qt(:,2).^2-qt(:,3).^2+qt(:,4).^2);
        yaw = atan2(-2*(qt(:,2).*qt(:,3)-qt(:,1).*qt(:,4)),qt(:,1).^2-qt(:,2).^2+qt(:,3).^2-qt(:,4).^2);
        plot(t, [pitch, roll, yaw]/deg); xygo('attitude / \circ');
        legend('pitch', 'roll', 'yaw');
    end

