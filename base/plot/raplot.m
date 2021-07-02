function res = raplot(data, r0, tau, rmax, rmin)
% RAvar plot.
%
% Prototype: res = raplot(data, r0, tau, rmax, rmin)
% Inputs: ....
%          
% See also  RAvarInit, RAvarUpdate.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 23/03/2018
    if ~exist('rmax', 'var'), rmax = 10*r0; end
    if ~exist('rmin', 'var'), rmin = 0.1*r0; end
    [n, m] = size(data);
    ts = diff(data(1:2,end));
    ra = RAvarInit(r0, tau, rmax, rmin);
    res = prealloc(n, m);
    for k=1:n
        ra = RAvarUpdate(ra, data(k,1:end-1)', ts);
        res(k,:) = [ra.R; data(k,end)]';
    end
    res(:,1:end-1) = sqrt(res(:,1:end-1));
    myfigure
    subplot(211), plot(data(:,end), data(:,1:end-1)), xygo('data');
    subplot(212), plot(res(:,end), res(:,1:end-1)), xygo('RAvar');
    
