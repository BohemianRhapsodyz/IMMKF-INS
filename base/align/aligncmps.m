function [att0, attk] = aligncmps(imu, qnb, pos, ctl0, ctl1, ts)
% SINS initial align uses gyro-compass method.
%
% Prototype: [att0, attk] = aligncmps(imu, qnb, pos, ctl0, ctl1, ts)
% Inputs: imu - IMU data
%         qnb - coarse attitude quaternion
%         pos - position
%         ctl0 - ctl0(1): level setting time in level align stage
%                ctl0(2): the lasting time for level align stage
%         ctl1 - ctl1(1): level setting time in yaw align stage
%         ctl1 - ctl1(2): gyro-compass setting time in yaw align stage 
%         ts - IMU sampling interval
% Outputs: att0 - attitude align result
%          attk - result array
%
% See also  gcctrl, alignfn, alignvn, aligni0, alignWahba, alignsb.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 23/12/2012
global glv
    if nargin<6,  ts = imu(2,7)-imu(1,7);  end
    if length(qnb)==3, qnb=a2qua(qnb); end  %if input qnb is Eular angles.
    nn = 2; nts = nn*ts;
    len = fix(length(imu)/nn)*nn;
    eth = earth(pos);
    wnie = eth.wnie; wN = wnie(2); wU = wnie(3); Cnn = rv2m(-wnie*nts/2);
    vn = [0;0]; dpos = [0;0];  wnc = [0;0;0]; % control parameters
    gc0 = gcctrl(ctl0(1));   gc1 = gcctrl(ctl1(1), ctl1(2));
    attk = prealloc(len/nn, 3); 
    ki = timebar(nn, len, 'Initial align using gyro-compass method.');
    for k=1:nn:len-nn+1
        wvm = imu(k:k+nn-1,1:6);
        [phim, dvbm] = cnscl(wvm);   wb = phim/nts; fb = dvbm/nts;
        Cnb = q2mat(qnb);
        qnb = qupdt(qnb, (wb-Cnb'*(wnie+wnc))*nts);  % attitude control princple
        fn = Cnn*Cnb*fb;
        vnr = [0; 0]; % reference velocity on static base
        if k*ts<ctl0(2)  % level control
            dVE = vn(1) - vnr(1);
            vn(1) = vn(1) + (fn(1)-gc0.kx1*dVE)*nts;
            dpos(1) = dpos(1) + dVE*gc0.kx3*nts;
            wnc(2) = dVE*(1+gc0.kx2)/glv.Re + dpos(1);
            dVN = vn(2) - vnr(2);
            vn(2) = vn(2) + (fn(2)-gc0.ky1*dVN)*nts;
            dpos(2) = dpos(2) + dVN*gc0.ky3*nts;
            wnc(1) = -dVN*(1+gc0.ky2)/glv.Re - dpos(2);
            wnc(3) = 0;
        else  % yaw control
            dVE = vn(1) - vnr(1);
            vn(1) = vn(1) + (fn(1)-gc1.kx1*dVE)*nts;
            dpos(1) = dpos(1) + dVE*gc1.kx3*nts;
            wnc(2) = dVE*(1+gc1.kx2)/glv.Re + dpos(1);
            dVN = vn(2) - vnr(2);
            vn(2) = vn(2) + (fn(2)-gc1.kz1*dVN)*nts;
            wnc(1) = -dVN*(1+gc1.kz2)/glv.Re;
            wnc(3) = (dVN*gc1.kz3*nts/wN+wnc(3))/(1+gc1.kz4*nts);
        end
        attk(ki,:) = q2att(qnb)';
        ki = timebar;
    end
    att0 = attk(end,:)';
    resdisp('Initial align attitudes (arcdeg)', att0/glv.deg);
    insplot([attk, (1:length(attk))'*nts]);    