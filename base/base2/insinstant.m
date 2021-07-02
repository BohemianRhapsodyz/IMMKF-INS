function avp1 = insinstant(imu, avp, t0, t1)
% Process pure INS for short time within [t0,t1].
%
% Prototype: avp = insinstant(imu, avp, t0, t1)
% Inputs: imu - SIMU data array
%         avp - AVP parameters, avp = [att,vn,pos,t]
%         t0 - start time in second.
%         t1 - end time in second.
% Output: avp1 - navigation results, avp1 = [att,vn,pos,t]
%
% See also  inspure, trjsimu, insupdate.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 23/06/2017
global glv
    if ~exist('t0', 'var'), t0 = avp(1,end); end
    if ~exist('t1', 'var'), t1 = imu(end,end); end
    idx0 = find(avp(:,end)>=t0,1);
    avp0 = avp(idx0,:)';
    idx0 = find(imu(:,end)>avp(idx0,end),1);
    idx1 = find(imu(:,end)>=t1,1);
    if length(avp0)<9, avp0 = [avp0(1:3); zeros(6,1)]; end
    avp1 = inspure(imu(idx0:idx1,:), avp0, 'f');   % imuplot(imu(idx0:idx1,:),1)
    avp = avp(idx0:idx1,:);
    t = avp(:,end);
	subplot(321), plot(t, avp(:,1:2)/glv.deg, '-.m', 'linewidth', 2); xygo('pr');
	subplot(322), plot(t, avp(:,3)/glv.deg, '-.m', 'linewidth', 2); xygo('y');
    if size(avp,2)>4
        subplot(323), plot(t, [avp(:,4:6),sqrt(avp(:,4).^2+avp(:,5).^2+avp(:,6).^2)], '-.m', 'linewidth', 2); xygo('V');
        subplot(325), plot(t, [[avp(:,7)-avp(1,7),(avp(:,8)-avp(1,8))*cos(avp(1,7))]*glv.Re,avp(:,9)-avp(1,9)], '-.m', 'linewidth', 2); xygo('DP');
        subplot(3,2,[4,6]), plot(0, 0, 'rp');   % 19/04/2015
            hold on, plot((avp(:,8)-avp(1,8))*glv.Re*cos(avp(1,7)), (avp(:,7)-avp(1,7))*glv.Re, '-.m', 'linewidth', 2); xygo('est', 'nth');
    end
