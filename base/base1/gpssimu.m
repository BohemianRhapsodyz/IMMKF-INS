function gpsVnPos = gpssimu(avp, dvn, dpos, tau, lever, imu_delay, isplot)
% GPS velocity&position simulator, it can be denoted as:
%     'vnGPS = vnSIMU + velLeverArm + TimeDelay + RandomError'
%     'posGPS = posSIMU + LeverArm + TimeDelay + RandomError'
%
% Prototype: gpsVnPos = gpssimu(avp, dpos, tau, lever, imu_delay, ifplot)
% Inputs: avp - avp info, always from trajectory simulation
%         dvn - standard deviation of velocity error
%         dpos - standard deviation of position error
%         tau - 1st Markov corelated time for position error
%         lever - GPS lever arm w.r.t SIMU
%         imu_delay - SIMU time delay w.r.t GPS 
% Output: gpsVnPos - [VE, Vn, VU, lat, lon, height, t]
%          
% See also  trjsimu, odsimu, bhsimu, gpsplot, markov1, la2dpos.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 19/02/2014, 23/02/2015
global glv
    if nargin<7,  isplot=0;   end
    if nargin<6,  imu_delay=0;   end
    if nargin<5,  lever=0;   end
    if nargin<4,  tau=1;   end
    if length(lever)==1,  lever=[lever;lever;lever];   end
    if length(tau)==1,   tau=[tau;tau];   end
    if length(tau)==2,   tau=[tau(1);tau(1);tau(1);tau(2);tau(2);tau(2)];   end
    if length(dvn)==1;   dvn=[dvn;dvn;dvn];   end
    if length(dpos)==1;   dpos=posseterr(dpos);   end
    %% find the nearest second in avp time
    idx = zeros(size(avp(:,end))); rt = idx; kk=1;
    gt = imu_delay;
    for k=1:length(avp)-1
        while gt<avp(k,end)
            gt = gt + 1;
        end
        if avp(k,end)<=gt && gt<avp(k+1,end)
            idx(kk) = k; rt(kk) = gt-avp(k,end); kk=kk+1;
        end
    end
    idx(kk:end) = [];
    %% add error
    ts = avp(2,end)-avp(1,end);
    gpsVnPos = zeros(length(idx),7); kk=1;
    for k=1:length(idx) % lever arm + time delay
        ik = idx(k);
        avpi = avpinterp(avp(ik,1:9),avp(ik+1,1:9),rt(k)/ts)';
        wnb = a2cwa(avp(ik+1,1:3)')*(avp(ik+1,1:3)-avp(ik,1:3))'/ts; % wnb~=web
        vngps = avpi(4:6)+a2mat(avpi(1:3)')*cros(wnb,lever);
        gpsVnPos(kk,:) = [vngps; avpi(7:9)+la2dpos(avpi, lever); round(avp(ik,end))]';  kk = kk+1;
    end
    dp = markov1([dvn;dpos], tau, 1, length(idx));  % 1st Markov error
    gpsVnPos(:,1:end-1) = gpsVnPos(:,1:end-1) + dp;
    if(isplot==1)
        gpsVnPos0 = gpsVnPos(1,1:6); gpsVnPos(1,1:6) = avp(1,4:9);
        gpsplot(gpsVnPos);
        subplot(221), hold on, plot(avp(:,end), avp(:,4:6), 'm-.');
        subplot(223), hold on, 
        plot(avp(:,end), [[avp(:,7)-avp(1,7),(avp(:,8)-avp(1,8))*cos(avp(1,7))]*glv.Re,avp(:,9)-avp(1,9)], 'm-.');
        gpsVnPos(1,1:6) = gpsVnPos0;
    end

