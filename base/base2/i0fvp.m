function [fi0, vi0, pi0] = i0fvp(t, lat)
% Calculate fi0,vi0,pi0 in i0 frame according to align time t.
%
% Prototype: [fi0, vi0, pi0] = i0fvp(t, lat)
% Inputs: t - alignment time from start
%         lat - initial latitude
% Outputs: fi0 - ideal specific force vector in i0-frame
%          vi0 - ideal apparent velocity vector in i0-frame
%          pi0 - ideal apparent position vector in i0-frame
%
% See also  aligni0, alignWahba.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 09/03/2014
global glv
    cL = cos(lat); tL = tan(lat);
    wt = glv.wie*t;
    swt = sin(wt); cwt = cos(wt); 
    fcL = glv.g0*cL;
    fi0 = fcL*[cwt; swt; tL];
    vi0 = fcL/glv.wie*[swt; 1-cwt; tL*wt];
    pi0 = fcL/glv.wie^2*[1-cwt; wt-swt; tL*wt^2/2];