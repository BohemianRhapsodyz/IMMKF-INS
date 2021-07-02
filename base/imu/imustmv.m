function [static, moving] = imustmv(imu, angrate)
% Calculate install matrix and scale factor from calibration matirx.
%
% Prototype: stmv = imustmv(imu, angrate)
% Inputs: Ks - gyro calibration matrix Ka (or acc calibration matrix Ka)
%         Cbs - gyro install matrix Cbg (or acc install matrix Cba)
%         K - gyro scale factor (or acc scale factor)
%
% See also  sumn, avar.

% Copyright(c) 2009-2016, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 24/10/2016
global glv
    ts = diff(imu(1:2,end));
    if nargin<2, angrate = 200*glv.dph; end
    rate = normv(imu(:,1:3));
    b = ones(200); b = b/sum(b);
    rate = filtfilt(b, 1, rate);
    stmv = rate/ts>angrate;
    stmv = diff(stmv);
    static = find(stmv==-1);  static = [1; static];
    moving = find(stmv==1);
    figure, subplot(211), plot(imu(:,end), imu(:,1:3)); xygo('Gyro');
        plot(imu(static,end), static*0, 'or',imu(moving,end), moving*0, 'ob');
    subplot(212), plot(imu(:,end), imu(:,4:6)); xygo('Acc');
        plot(imu(static,end), static*0, 'or',imu(moving,end), moving*0, 'ob');        