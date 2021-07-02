function alt = altfilt(alt, dh, r, ts)
% Pure SINS altitude damping using Kalman filter.
%
% Prototype: alt = altfilt(alt, dh, r, ts)
% Initialization: alt = altfilt(tau, q, r, ts)
%      where tau, q are altitude accelerometer corelated time and noise;
%      r is altitude measurement error; ts is sampling interval.
%      Output alt is filter structure array.
% Time-update: alt = altfilt(alt)
% Measurement-update: alt = altfilt(alt, dh)
%      where dh is altitude error, i.e. the diference between pure SINS 
%      altitude and reference altitude.
% The Kalman filter models are as follows:
%          |da|      |-1/tau 0 0| |da|   |W|
%   Sys:  d|dv|/dt = | 1     0 0|*|dv| + |0|
%          |dh|      | 0     1 0| |dh|   |0|
%   Meas: Z = dh + V
%
% See also  inspure, insupdate, kfupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 10/04/2014, 23/01/2017
global glv
    if nargin>2      % kf initialization, alt = altfilt(tau, q, r, ts)
        tau = alt; q = dh;
        Ft = [-1/tau,0,0; 1,0,0; 0,1,0];
        alt = [];
        alt.Phikk_1 = expm(Ft*ts); % eye(3) + Ft*ts;
        alt.Qk = diag([q; 0; 0])^2*ts;
        alt.Hk = [0, 0, 1];
        alt.Rk = r^2;
        alt.xk = [0; 0; 0];
        alt.Pxk = diag([glv.mg; 1; 100])^2;
        alt.adaptive = 0;
        alt.fading = 1;
        alt.xconstrain = 0;
        alt.pconstrain = 0;
        alt.Gammak = 1;
    elseif nargin==2 % measurement update
        alt = kfupdate(alt, dh, 'M');
    else             % time update
        alt = kfupdate(alt);
    end
