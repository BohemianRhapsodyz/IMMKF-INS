function res = vgtest(imu, att, T)
% VG attitude test.
%
% Prototype: res = vgtest(imu, att, T)
% Inputs: imu - IMU data array
%         att - VG ref attitude
%         T - periodic reset interval
% Output: res - free attitude update periodicly reset by att
% 
% See also  N/a.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 29/07/2017
global glv
    if nargin<3, T=10; end
    len = length(imu);
    [nn, ts, nts] = nnts(4, (imu(end,end)-imu(1,end))/(len-1));
    qInt = a2qua(att(1,1:3)); vnInt = [0;0;0];
    qIntT = 0;
    res = zeros(len,16);  kk=1;
    timebar(1, len/nn);
    for k=1:nn:len-nn
        k1 = k+nn-1;
        [phim, dvbm] = cnscl(imu(k:k1,:));
        if qIntT>=T
            qInt = a2qua(att(k,1:3));  vnInt = [0;0;0];  qIntT = 0;
        else
            fn = qmulv(qInt,dvbm)/nts;
            vnInt = vnInt + fn+[0;0;-9.8]*nts;
            qInt = qmul(qInt, rv2q(phim));
        end
        qIntT = qIntT + nts;
        res(kk,:) = [q2att(qInt); fn; vnInt; att(k1,:)'; dvbm/nts]'; kk = kk+1;
        timebar;
    end
    res(kk:end,:) = [];
    figure
    idx = (res(:,4)==0);
    subplot(211); plot(res(:,13), res(:,1:2)/glv.deg); xygo('pr');
        hold on, plot(res(:,13), res(:,10:11)/glv.deg, 'm', res(idx,13), res(idx,1:2)/glv.deg, 'ro');
    subplot(212); plot(res(:,13), res(:,7:8)); xygo('V');
     