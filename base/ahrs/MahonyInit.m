function ahrs = MahonyInit(tau, att0, t0)
% The initialization of AHRS using Mahony method. The transfer function is
% as follow:
%         s*Kp+Ki                s
%  dq = ----------- * fb  +  ----------- * wb
%       s^2+s*Kp+Ki          s^2+s*Kp+Ki
%
% Prototype: ahrs = MahonyInit(tau)
% Inputs: tau - time constant, Delta(s) = s^2+Kp*s+Ki
%                                       = s^2+2*beta*s+beta^2
%                              where beta = 1/tau
%         att0 - initial attitude
%         t0   - initial time
% Output: ahrs - output AHRS structure array
%
% See also  MahonyUpdate, QEAHRSInit.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 07/06/2017
    if ~exist('att0', 'var')
        q = [1;0;0;0];
    else
        la = length(att0);
        if la==4,     q = att0;
        elseif la==0, q = [1;0;0;0];
        else          q = a2qua(att0);  end
    end
    ahrs.flt = iirflt([4,0.02]);
    ahrs.q = q;  ahrs.Cnb = q2mat(ahrs.q);
    ahrs.exyzInt = [0;0;0];
    if ~exist('tau', 'var'), tau = 4; end
    if tau<=0.1
        ahrs.adaptive = 1;
    else
        ahrs.adaptive = 0;
        beta = 2.146/tau;
        ahrs.Kp = 2*beta; ahrs.Ki = beta^2;
    end
    if ~exist('t0', 'var'), t0 = 0; end
    ahrs.tk = t0;
    ahrs.qInt = ahrs.q;  ahrs.vnInt = [0;0;0]; ahrs.qIntT = 0;

