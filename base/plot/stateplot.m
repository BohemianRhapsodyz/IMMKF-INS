function stateplot(state)
% Runing-state plot.
%
% Prototype: stateplot(state)
% Input: state - runing state
%          
% See also  imuplot, insplot, inserrplot, kfplot, gpsplot.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 18/03/2017
    [n, m] = size(state);
    if m==1,  t = (1:n)';
    else      t = state(:,2); end
    sstate = [];
    for k=0:31
        tmp = bitand(state(:,1),2^k);
        mtmp = max(tmp);
        if mtmp>0, sstate = [sstate, tmp/mtmp*(k+1)]; end
    end
    figure, plot(t, sstate, '*');  xygo('Running-state');

