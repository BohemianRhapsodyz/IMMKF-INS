function [wvm, avp] = scullsimu(Ae, Ap, f, ts, T)
% Sculling motion (drift about z-axis) simulation.
% Inputs: Ae - angular amplitude
%        Ap - linear amplitude
%        f - sculling frequency (in Hz)
%        ts - sampling interval
%        T - total simulation time
% Outputs: [      wvm1, wvm2, ..., wvmN]; angular & velocity increment
%          [avp0, avp1, avp2, ..., avpN ]; attitude, velocity & position reference
%
% See also  conesimu, trjsimu, sculldrift.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 03/11/2013, 11/04/2014
    if nargin<5,  T = 10/f;  end  % the default T is 10 cycles
    omega = 2*pi*f;
    t = (0:ts:T)'; len = length(t);
    o = zeros(len,1);
    st = sin(omega*t);  ct = cos(omega*t); 
    sct = sin(Ae*ct);   cct = cos(Ae*ct);
    % 'vbz' is the integral of centripetal acceleration:
    % wt*Vt=Ae*Ap*omega^2*sin(omega*t)^2
    vby = -Ap*omega*st;    % total increments
    vbz = Ae*Ap*omega*1/2*(omega*t-1/2*sin(2*omega*t));
    wvm = [Ae*ct,o,o,  o,vby,vbz];  % Ref. Qin P333
    wvm = diff(wvm);
%     dgx=-2*Ae*sin(omega*ts/2)*sin(omega*(t+ts/2));
%     day=-2*Ap*omega*sin(omega*ts/2)*cos(omega*(t+ts/2));
%     daz=Ae*Ap*omega/2*(omega*ts-sin(omega*ts)*cos(2*omega*(t+ts/2)));
%     wvm=[dgx,o,o,  o,day,daz]; wvm=wvm(1:end-1,:);   
    L = Ap/Ae; % lever arm or radius
    avp = [Ae*ct,o,o,  o,vby.*cct,vby.*sct,  o,L*sct,L*(1-cct)];

