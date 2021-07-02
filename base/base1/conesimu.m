function [wm, qt, wt] = conesimu(afa, f, ts, T)
% Coning motion (drift about x-axis) simulation.
%
% Prototype: [wm, qt, wt] = conesimu(afa, f, ts, T)
% Inputs: afa - half-apex angle
%        f - coning frequency (in Hz)
%        ts - sampling interval
%        T - total simulation time
% Outputs: wm = [      wm1,  wm2, ... , wmN ]';    % angular increment
%          qt = [ q0,  q1,   q2,  ... , qN  ]';    % quaternion reference
%          wt = [ w0,  w1,   w2,  ... , wN  ]';    % angular rate
%
% See also  scullsimu, trjsimu, conecoef, conedrift, highmansimu.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 03/11/2013
    if nargin<4,  T = 10/f;  end  % the default T is 10 cycles
    omega = 2*pi*f;
    t = (0:ts:T)';
    wm = [ -2*omega*ts*sin(afa/2)^2*ones(size(t)), ...
           -2*sin(afa)*sin(omega*ts/2)*sin(omega*(t+ts/2)), ...
            2*sin(afa)*sin(omega*ts/2)*cos(omega*(t+ts/2))  ];
    wm(end,:) = [];       
    qt = [ cos(afa/2)*ones(size(t)), ...
           zeros(size(t)), ...
           sin(afa/2)*cos(omega*t), ...
           sin(afa/2)*sin(omega*t)   ];
    if nargout==3
        wt = [ -2*omega*sin(afa/2)^2*ones(size(t)), ...  % angular rate
               -omega*sin(afa)*sin(omega*t), ...
                omega*sin(afa)*cos(omega*t)];
        % plot([wm(:,:)/ts- (wt(1:end-1,:)+wt(2:end,:))/2]);
    end

