function [wm, att] = swaysimu(afa, f, phase0, ts, T)
% Sway simulation with pitch,roll,yaw(center-,inner-,outer-frame) 
% on turntable, neglecting earth angular rate (i.e. w.r.t. inetial frame).
%
% Prototype: [wm, att] = swaysimu(afa, f, phase0, ts, T)
% Inputs: afa - sway amplitude (in degree)
%        f - sway frequency (in Hz)
%        phase - sway initial-phase (in degree)
%        ts - sampling interval
%        T - total simulation time
% Outputs: wm  = [      wm1,  wm2, ... , wmN ]';    % angular increment
%          att = [att0, att1, att2, ..., attN]';
%
% See also  conesimu.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 28/08/2013
    if length(afa)==1, afa=[afa;afa;afa]; end
    if length(f)==1, f=[f;f;f]; end
    if length(phase0)==1, phase0=[phase0;phase0;phase0]; end
    if nargin<5,  T = 10/min(f);  end  % the default T is 10 cycles
    afa = afa*pi/180;
    omega = 2*pi*f;
    phase0 = phase0*pi/180;
    n10=10; t = (0:ts/n10:T)';
    pitch = afa(1)*sin(omega(1)*t+phase0(1));
    roll = afa(2)*sin(omega(2)*t+phase0(2));
    yaw = afa(3)*sin(omega(3)*t+phase0(3));
    dpitch = afa(1)*omega(1)*cos(omega(1)*t+phase0(1));
    droll = afa(2)*omega(2)*cos(omega(2)*t+phase0(2));
    dyaw = afa(3)*omega(3)*cos(omega(3)*t+phase0(3));
    sp = sin(pitch); cp = cos(pitch); sr = sin(roll); cr = cos(roll);
    wb = [cr.*dpitch-sr.*cp.*dyaw, ...   % angular rate
          droll+sp.*dyaw, ...
          sr.*dpitch+cr.*cp.*dyaw];
    wm = cumint(wb, ts/n10);
    wm = diff(wm);
    wm = sumn(wm, n10);
    k = 1:10:length(t);
    att = [pitch(k,:), roll(k,:), yaw(k,:), t(k,:)];

