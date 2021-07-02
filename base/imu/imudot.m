function dotwf = imudot(imu, passband, iffig)
% Compute the angular acceleration & jerk from SIMU data.
%
% Prototype: dotwf = imudot(imu, passband, iffig)
% Inputs: 
%    imu - raw SIMU data
%    passband - low-pass band to filter SIMU data
%    iffig - figure flag for dotwf
% Output: dotwf - = [dot_w, dot_f, t], 
%                   dot_w = d(w)/dt in rad/s^2, dot_f = d(f)/dt in m/s^3
%
% See also  imuresample.

% Copyright(c) 2009-2016, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi'an, P.R.China
% 16/08/2016
    global glv
    ts = diff(imu(1:2,end));
    b = fir1(10, passband*ts,'low'); a = 1;
    dotwf = diff([imu(1,1:6); imu(:,1:6)]);
%     dotwf = [filter(b, a, dotwf)/ts^2, imu(:,end)];  % post-process only
    dotwf = [filtfilt(b, a, dotwf)/ts^2, imu(:,end)];  % post-process only
    if nargin<3, iffig = 0; end
    if iffig==1
        myfigure;
        subplot(121), plot(dotwf(:,end), dotwf(:,1:3)/glv.deg), xygo('dw/dt / \circ/s^2')
            hold on,  plot(imu(:,end), imu(:,1:3)/ts/glv.dps, '-.');
        subplot(122), plot(dotwf(:,end), dotwf(:,4:6)/9.8), xygo('df/dt / g/s')
            hold on,  plot(imu(:,end), imu(:,4:6)/ts/glv.g0, '-.');
    end
 