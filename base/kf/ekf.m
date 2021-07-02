function kf = ekf(kf, yk)
% Extended Kalman filter for nonlinear system.
%
% Prototype: kf = ekf(kf, yk)
% Inputs: kf - filter structure array
%        yk - measurement vector
% Output: kf - output filter structure array
% Notes: user must realize the following two nonlinear propagations:
%    xkk_1 = f(xk_1)
%    ykk_1 = h(xkk_1) 
% outside this function.
%
% See also  ukf, kfupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 27/09/2012
    % kf.xkk_1 = kf.Phikk_1*kf.xk; % if linear
    kf.Pxkk_1 = kf.Phikk_1*kf.Pxk*kf.Phikk_1' + kf.Qk;
    if nargin<2    % time updating only
        kf.xk = kf.xkk_1; kf.Pxk = kf.Pxkk_1;
        return;
    end
    kf.Pxykk_1 = kf.Pxkk_1*kf.Hk';
    kf.Pykk_1 = kf.Hk*kf.Pxykk_1 + kf.Rk;
    kf.Kk = kf.Pxykk_1*kf.Pykk_1^-1;
    % kf.ykk_1 = kf.Hk*kf.xkk_1; % if linear
    kf.xk = kf.xkk_1 + kf.Kk*(yk-kf.ykk_1);
    kf.Pxk = kf.Pxkk_1 - kf.Kk*kf.Pykk_1*kf.Kk';
    kf.Pxk = (kf.Pxk+kf.Pxk')/2;
