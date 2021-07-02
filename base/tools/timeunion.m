function [i1, i2] = timeunion(t1, t2)
% Extract data index sharing the same sampling time interval, according to 
% time tags t1 & t2.
%
% Prototype: [i1, i2] = datacut(t1, t2)
% Inputs: t1, t2 - input sampling time index arrays
% Outputs: i1, i2 - output index sharing the same sampling time interval

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 17/06/2014
    if t1(1)>=t2(1)
        t1s = 1;
        t2s = find(t2-t1(1)>=0,1);
    else
        t1s = find(t1-t2(1)>=0,1);
        t2s = 1;
    end
    if isempty(t1s) || isempty(t2s)
        error('No matching index found.');
    end
    if t1(end)<=t2(end)
        t1e = length(t1);
        t2e = find(t2-t1(end)>=0,1);
    else
        t1e = find(t1-t2(end)>=0,1);
        t2e = length(t2);
    end
    i1 = (t1s:t1e)';
    i2 = (t2s:t2e)';

