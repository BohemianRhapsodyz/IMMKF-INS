function davp = dsins(wf, avp)
% SINS differential equations. Make sure that the Euler angles must not
% be sigular.
%
% Prototype: davp = dsins(wf, avp)
% Inputs: wf - wf = [wb, fb], wb for gyro angular rate and fb for acc
%              specific force
%         avp - avp = [att, vn, pos], Euler angles, velocity & position
% Output: avp - d(avp)/dt
%
% See also  rgkt4.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 05/05/2014
    wb = wf(1:3);  fb = wf(4:6);
    att = avp(1:3);  vn = avp(4:6);  pos = avp(7:9);
    s = sin(att); c = cos(att);
    si = s(1); sj = s(2); sk = s(3);
    ci = c(1); cj = c(2); ck = c(3);  ti = si/ci;
    Caw = [  cj,     0,  sj;
             sj*ti,  1, -cj*ti;
            -sj/ci,  0,  cj/ci ];  % a2caw
    Cnb = [ cj*ck-si*sj*sk, -ci*sk,  sj*ck+si*cj*sk;
            cj*sk+si*sj*ck,  ci*ck,  sj*sk-si*cj*ck;
           -ci*sj,           si,     ci*cj           ]; % a2mat
    eth = earth(pos, vn);
    datt = Caw*(wb-Cnb'*eth.wnin);
    dvn = Cnb*fb + eth.gcc;
    dpos = [vn(2)/eth.RMh;vn(1)/eth.clRNh;vn(3)];
    davp = [datt; dvn; dpos];