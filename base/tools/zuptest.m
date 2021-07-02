function zuptt = zuptest(imu, static_time)
% ZUPT time test.
%
% Prototype: zuptt = zuptest(imu, static_time)
% Inputs: imu - IMU data
%         static_time - ZUPT static time
% Output: zuptt - ZUPT time point
%
% See also  imuresample, imuplot.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 14/04/2018
global glv
    imu = imuresample(imu, 1.0);
    len = length(imu);
    if ~exist('static_time', 'var'), static_time = 30; end
    zuptt = zeros(100,1); t1 = 1; kk = 1;
    for k=1:len
        t2 = t1 + static_time;
        if t2>len, break; end
        if mean(normv(imu(t1:t2,1:3)))<0.02*glv.dps && ...
            std(normv(imu(t1:t2,1:3)))<0.02*glv.dps && ...
            std(normv(imu(t1:t2,4:6)))<10*glv.mg
            zuptt(kk) = t1; kk = kk+1;
            t1 = t1 + 100;
        else
            t1 = t1 + 1;
        end
    end
    zuptt(kk:end) = [];
    zuptt = zuptt + 2;
    imuplot(imu,1);
    subplot(121), plot(zuptt,imu(zuptt,1:3)/glv.dps,'*m');
    subplot(122), plot(zuptt,imu(zuptt,4:6)/glv.g0,'*m');

