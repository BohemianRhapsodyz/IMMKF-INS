function [phim, dvbm] = cnscl0(imu)
% Coning & sculling compensation, much faster than 'cnscl'. Make sure
% sub-sample number less than 6.
%
% Prototype: [phim, dvbm] = cnscl0(imu, coneoptimal)
% Input:  imu(:,1:3) - gyro angular increments
%         imu(:,4:6) - acc velocity increments
% Outputs: phim - rotation vector after coning compensation
%          dvbm - velocity increment after rotation & sculling compensation
%
% See also  cnscl.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 22/05/2014

% global glv % more time wasting
    cs = [                      % coning & sculling compensation coefficients
        [2,    0,    0,    0,    0    ]/3
        [9,    27,   0,    0,    0    ]/20
        [54,   92,   214,  0,    0    ]/105
        [250,  525,  650,  1375, 0    ]/504
        [2315, 4558, 7296, 7834, 15797]/4620 ];
    n = size(imu, 1);  n1 = 1:n-1;
	if n==1
        phim = imu(1:3)';
        dvbm = (imu(4:6)+0.5*cros(imu(1:3),imu(4:6)))';
    else
        wvmm = sum(imu,1);
        imun = imu(n,:);
        csm = cs(n-1,n1)*imu(n1,:);
%         dphim = cros(csm(1:3),imu(n,1:3));
%         phim = (wvmm(1:3)+dphim)';
        phim = [ wvmm(1) + csm(2)*imun(3)-csm(3)*imun(2);
            	 wvmm(2) + csm(3)*imun(1)-csm(1)*imun(3);
            	 wvmm(3) + csm(1)*imun(2)-csm(2)*imun(1) ];
%         scullm = cros(csm(1:3),imu(n,4:6)) + cros(csm(4:6),imu(n,1:3));
%         dvbm = (wvmm(4:6)+0.5*cros(wvmm(1:3),wvmm(4:6))+scullm)';
        dvbm = [ wvmm(4) + 0.5*(wvmm(2)*wvmm(6)-wvmm(3)*wvmm(5)) + ...
                    csm(2)*imun(6)-csm(3)*imun(5) + csm(5)*imun(3)-csm(6)*imun(2);
            	 wvmm(5) + 0.5*(wvmm(3)*wvmm(4)-wvmm(1)*wvmm(6)) + ...
                    csm(3)*imun(4)-csm(1)*imun(6) + csm(6)*imun(1)-csm(4)*imun(3);
            	 wvmm(6) + 0.5*(wvmm(1)*wvmm(5)-wvmm(2)*wvmm(4)) + ...
                    csm(1)*imun(5)-csm(2)*imun(4) + csm(4)*imun(2)-csm(5)*imun(1) ];
	end

