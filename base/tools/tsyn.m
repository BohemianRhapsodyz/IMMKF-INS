function idx = tsyn(t1, t2)
% Time synchronization.
% 
% Prototype: idx = tsyn(t1, t2)
%
% See also  insupdate, kfupdate, POSProcessing.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 10/07/2015
    idx = zeros(size(t1));
    [junk, i1, i2] = intersect(t1, t2);
    idx(i1) = i2;