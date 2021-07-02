function [t, t0] = dhms2t(dhms, t0)
% convert date/hour/minute/second to continous second.
%
% Prototype: [t, t0] = dhms2t(dhms, t0)
% Inputs: dhms - date/hour/minute/second array data,
%                like 12d34h56m12.3456s (with no 'dhms' letters)
%          t0 - start time
% Outputs: t - continous second
%          t0 - start time
%
% See also  cnt2t, datenum.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 12/12/2018
    d = fix(dhms*1e-6);
    hms = dhms-d*1e6;
    h = fix(hms*1e-4);
    ms = hms-h*1e4;
    m = fix(ms*1e-2);
    s = ms-m*1e2;
    t = d*(24*3600) + h*3600 + m*60 + s;
    if ~exist('t0', 'var')
        t0 = t(1);
    end
    t = t - t0;