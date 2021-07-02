function [imu, avp] = seawavesimu(dA, pA, dP, pP, ts, T, pos0, yaw0)
% Vessel swaying simulation under sea-wave environment.
%
% Prototype: [imu, avp] = seawavesimu(dA, wA, dP, wP, ts, T, pos0, yaw0)
% Inputs: dA - wave angular amplitudes (in rad)
%        pA - wave angular period (in second)
%        dP - wave linear amplitudes (in meter)
%        pP - wave linear period (in second)
%        ts - sampling interval (in second)
%        T - total simulation time (in second)
%        pos0 - initial position [lat,lon,hgt] (in rad & m)
%        yaw0 - initial body yaw (in rad)
% Outputs: imu - IMU data
%          avp - AVP parameter
%
% Example:
%        glvs;
%        [imu, avp0] = seawavesimu([5;5;3]*glv.deg, [5;7;10], [1;1;0.5], [5;7;10], 0.01, 60, 34*glv.deg, 30*glv.deg);
%        avp = inspure(imu, avp0(1,:)', 'f'); 
%        avperr = avpcmp(avp, avp0);
%        inserrplot(avperr);

% See also  ap2avp, avp2imu.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 28/08/2013
    if length(dA)==1, dA = repmat(dA,3,1); end
    if length(pA)==1, pA = repmat(pA,3,1); end
    if length(dP)==1, dP = repmat(dP,3,1); end
    if length(pP)==1, pP = repmat(pP,3,1); end
    if ~exist('pos0', 'var'), pos0 = 0; end
    if length(pos0)==1, pos0 = [pos0;0;0]; end
    if ~exist('yaw0', 'var'), yaw0 = 0; end
    
    dAP = [dA(:); dP(:)]; wAP = ts./[pA(:), pP(:)];  maxP=max([pA(:); pP(:)]);
    len = fix(T/ts);
    AP = randn(5*fix(maxP/ts)+len,6);
    for k=1:6
        [b, a] = butter(2, [wAP(k)*0.8, wAP(k)*1.2]);  % Bandpass filter
        AP(:,k) = filter(b,a,AP(:,k));
    end
    AP = AP(end-len+1:end,:);
    for k=1:6
        AP(:,k) = dAP(k)/2.5/std(AP(:,k))*AP(:,k);
    end
    AP(:,3) = AP(:,3)+yaw0;
    eth = earth(pos0);
    AP(:,4:6) = AP(:,4:6)*a2mat([0;0;-yaw0]);
    AP(:,4:6) = [AP(:,4)/eth.RMh+pos0(1), AP(:,5)/eth.clRNh+pos0(2) AP(:,6)+pos0(3)];
    AP(:,7) = (0:length(AP)-1)*ts;
    
    avp = ap2avp(AP, ts);
    imu = avp2imu(avp);

