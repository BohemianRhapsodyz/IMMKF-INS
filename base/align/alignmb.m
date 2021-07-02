function [att, qnb] = alignmb(imu, vnGPS)
% SINS coarse align on high-moving base aided by GPS.
%
% Prototype: [att, qnb] = alignmb(imu, vnGPS)
% Inputs: imu - SIMU data (100Hz)
%         vnGPS - GPS velocity (1Hz), two data set should align as the following:
%                       imu(1,:) ... imu(100,:) ... imu(200,:) ...
%            vnGPS(1,:)     ...      vnGPS(2,:) ... vnGPS(3,:) ...
% Outputs: att, qnb - attitude align results Euler angles & quaternion
%
% See also  dv2atti, alignvn, aligncmps, aligni0, insupdate.

% Copyright(c) 2009-2016, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 26/07/2016
    ts = 0.01;
    qb0b = [1;0;0;0]; vb0 = [0;0;0];  res = zeros(fix(length(imu)/100), 11);
    vn0 = vnGPS(1,1:3)';  kk = 1;
    for k=1:length(imu)
        vb0 = vb0 + qmulv(qb0b,imu(k,4:6)');
        qb0b = qupdt(qb0b, imu(k,1:3)');  attk(k,:) = [q2att(qb0b);imu(k,end)];
        if mod(k,100)==0
            res(kk,:) = [qb0b; vnGPS(kk+1,1:3)'-vn0+[0;0;9.8]; vb0; imu(k,end)]';  kk = kk+1;
            vn0 = vnGPS(kk+1,1:3)'; vb0 = [0;0;0];
        end
    end
    qnb0 = mv2atti(res(:,5:7), res(:,8:10));
    qnb = qmul(qnb0,qb0b);
    att = q2att(qnb);

