function ahrs = MahonyUpdate(ahrs, imu, mag, ts)
% AHRS using Mahony method.
%
% Prototype: ahrs = MahonyUpdate(ahrs, imu, mag, ts)
% Inputs: ahrs - AHRS structure array
%        imu - [wm, vm] gyro & acc increment samples
%        mag - magetic output in mGauss (or any unit)
%        ts - sample interval
% Output: ahrs - output AHRS structure array
%
% See also  MahonyInit, QEAHRSUpdate.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 07/06/2017
    [phim, dvbm] = cnscl(imu);  nts = size(imu,1)*ts;  % nts = imu(end,7)-imu(1,7);
    nm = norm(dvbm);
    if nm>0, acc = dvbm/nm;  else  acc = [0;0;0];  end
    ahrs.flt = iirflt(ahrs.flt, dvbm/nts); fb = ahrs.flt.y(1:3,1);
    if ahrs.adaptive==1
        nm1 = abs(norm(fb)-9.8);  ahrs.nm1 = nm1;
        if nm1<0.03
            tau = interplim([0, .03], [3, 10], nm1);
        elseif nm1<0.1
            tau = interplim([0.03, .1], [10, 20], nm1);
%         elseif nm1<0.5
%             tau = interplim([0.1, .5], [20, 50], nm1);
%         else
%             tau = interplim([.5, 15], [50, 100], nm1);
        else
            tau = interplim([.1, 150], [300000, 500000], nm1);
        end
        beta = 2.146/tau;
        ahrs.Kp = 2*beta; ahrs.Ki = beta^2;
    end
    nm = norm(mag);
    if nm>0, mag = mag/nm;  else  mag = [0;0;0];  end
    bxyz = ahrs.Cnb*mag;
    bxyz(1:2) = [0;norm(bxyz(1:2))];
    wxyz = ahrs.Cnb'*bxyz;
    exyz = cros(ahrs.Cnb(3,:)',acc) + cros(wxyz,mag);
%     exyz1 = angle3d(ahrs.Cnb(3,:)',acc) + angle3d(wxyz,mag)*0;
    ahrs.exyzInt = ahrs.exyzInt + exyz*ahrs.Ki*nts;
%     ahrs.flt = iirflt(ahrs.flt, ahrs.exyzInt); ahrs.exyzInt = ahrs.flt.y(:,1);
    ahrs.q = qmul(ahrs.q, rv2q(phim-0*(ahrs.Kp*exyz+ahrs.exyzInt)*nts));
    ahrs.Cnb = q2mat(ahrs.q);
    ahrs.tk = ahrs.tk + nts;
    %%
    ahrs.qIntT = ahrs.qIntT + nts;  % pure integral test
    if ahrs.qIntT>100
        ahrs.qInt = ahrs.q;  ahrs.vnInt = [0;0;0];  ahrs.qIntT = 0;
    else
        ahrs.vnInt = ahrs.vnInt + qmulv(ahrs.qInt,dvbm)+[0;0;-9.8]*nts;
        ahrs.qInt = qmul(ahrs.qInt, rv2q(phim));
    end

