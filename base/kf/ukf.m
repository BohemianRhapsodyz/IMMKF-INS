function kf = ukf(kf, yk)
% Unscented Kalman filter for nonlinear system.
%
% Prototype: kf = ukf(kf, yk)
% Inputs: kf - filter structure array
%         yk - measurement vector
% Output: kf - filter structure array after time/meas updating
%
% See also  ut, ekf, kfupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 27/09/2012
    if isfield(kf, 'fx')  % nonliear state propagation
        [kf.xkk_1, kf.Pxkk_1] = ut(kf.xk, kf.Pxk, kf.fx, kf.px, 1e-3, 2, 0);
        kf.Pxkk_1 = kf.Pxkk_1 + kf.Qk;
    else
        kf.xkk_1 = kf.Phikk_1*kf.xk;
        kf.Pxkk_1 = kf.Phikk_1*kf.Pxk*kf.Phikk_1' + kf.Qk;
    end
    if nargin<2    % time updating only
        kf.xk = kf.xkk_1; kf.Pxk = kf.Pxkk_1;
        return;
    end
    
    if isfield(kf, 'hx')  % nonliear measurement propagation
        [kf.ykk_1, kf.Pykk_1, kf.Pxykk_1] = ut(kf.xkk_1, kf.Pxkk_1, kf.hfx, kf.py, 1e-3, 2, 0);
        kf.Pykk_1 = kf.Pykk_1 + kf.Rk;
    else
        kf.ykk_1 = kf.Hk*kf.xkk_1;
        kf.Pxykk_1 = kf.Pxkk_1*kf.Hk';    kf.Pykk_1 = kf.Hk*kf.Pxykk_1 + kf.Rk;
    end
    % filtering
    kf.Kk = kf.Pxykk_1*kf.Pykk_1^-1;
    kf.xk = kf.xkk_1 + kf.Kk*(yk-kf.ykk_1);
    kf.Pxk = kf.Pxkk_1 - kf.Kk*kf.Pykk_1*kf.Kk';  kf.Pxk = (kf.Pxk+kf.Pxk')/2;
