function [imu, avp] = trjunilat(avp0, ts, T, imuerr)
% SIMU sensor incremental outputs, flying along the same latitude and
% on a uniform eastern-velocity.
%
% Prototype: [imu, avp] = trjunilat(avp0, ts, T, imuerr)
% Inputs: avp0 - initial avp0=[att0,vn0,pos0], where vn0(2)=vn0(3)=0
%         ts - SIMU sampling interval
%         T - total sampling simulation time
%         imuerr - SIMU error setting structure array from imuerrset
% Outputs: imu - SIMU data imu = [gyro;acc;t]
%          avp - trajectory avp = [attitude;velocity;position;t]
% 
% See also  trjEast, trjNorth, trjsimu, imustatic.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 06/04/2014
    Cbn = a2mat(avp0(1:3))';
    eth = earth(avp0(7:9), avp0(4:6));
    imu = [Cbn*eth.wnin; -Cbn*eth.gcc]';
    len = round(T/ts);
    imu = repmat(imu*ts, len, 1);
    if nargin==4
        imu = imuadderr(imu, imuerr, ts);
    end
    imu(:,7) = (1:len)'*ts;
    avp = repmat(avp0(:)', len, 1);
    dlon = avp0(4)*ts/eth.clRNh;
    avp(:,8) = avp(1,8) + (1:len)'*dlon;
    avp(:,10) = imu(:,7);