function apt = seawave6(apTau, T, ts, t0, t1, isfig)
% 6-DOF attitude & position simulation under sea condition.
%
% Prototype: apt = seawave6(apTau, T, ts, t0, t1)
% Inputs: apTau - 6x3 array
%         T -  sway interval
%         ts - sampling cycle
%         t0,t1 -  start&stop static lasting interval
% Output: apt - attitude, position & time data
%
% Example:
%   apTau = [10, 6, 12   % pitch, cycle_low ~ cycle_high
%            15, 7, 10   % roll,  cycle_low ~ cycle_high
%            5, 10, 15   % yaw,   cycle_low ~ cycle_high
%            200, 6, 8   % sway,  cycle_low ~ cycle_high
%            100, 5, 10  % surge, cycle_low ~ cycle_high
%            160, 8, 15  % heave, cycle_low ~ cycle_high
%           ];
% apt = seawave6(apTau, 100, 0.01, 10, 10);
%
% See also  imustatic.

% Copyright(c) 2009-2019, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 23/06/2019
    if ~exist('t1', 'var'), t1 = 20; end
    if ~exist('t0', 'var'), t0 = 10; end
    if ~exist('ts', 'var'), ts = 0.01; end
    ts0 = ts; ts = 1; 
    t = (0:ts:T+t0+t1)';
    apt1 = zeros(length(t),7); apt1(:,end) = t;
    apt1(fix(t0/ts):fix((t0+T)/ts),1:6) = randn(fix((t0+T)/ts)-fix(t0/ts)+1,6);
    for k=1:6
        if size(apTau,2)<3
            [b, a] = butter(6, [1/apTau(k,2)]/(0.5/ts), 'low');
        else
            [b, a] = butter(6, [1/apTau(k,3),1/apTau(k,2)]/(0.5/ts), 'bandpass');
        end
%         apt1(:,k) = filtfilt(b,a,apt1(:,k))*apTau(k,3);
        thres = 1.0;
        idx = apt1(:,k)>thres;  apt1(idx,k) = thres;
        idx = apt1(:,k)<-thres;  apt1(idx,k) = -thres;
        apt1(:,k) = filter(b,a,apt1(:,k));
    end
    afa = 1;
    for k=fix((T+t0)/ts):length(apt1)
        apt1(k,1:6) = afa*apt1(k,1:6); afa = afa*0.5;
    end
    for k=1:6
        apt1(abs(apt1(:,k))<1e-5,k) = 0;
    end
    t = (t(1):ts0:t(end))'; apt = zeros(length(t),7); apt(:,end) = t;
    for k=1:6
%         apt(:,k) = interp1(apt1(:,end), apt1(:,k), t);
        apt(:,k) = interp1(apt1(:,end), apt1(:,k), t, 'spline');
        apt(:,k) = apt(:,k)/std(apt(:,k))*apTau(k,1)*2/3;
    end
    if ~exist('isfig','var'), isfig=0; end
    if isfig==1
        figure, subplot(211), plot(t, apt(:,1:3)/(pi/180)), xygo('Att / \circ')
        subplot(212), plot(t, apt(:,4:6)*1000), xygo('Pos / mm')
    end
