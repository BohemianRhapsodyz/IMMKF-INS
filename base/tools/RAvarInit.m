function ra = RAvarInit(r0, tau, rmax, rmin, maxCount0)
% 计算时间序列的方差，参考《惯性仪器测试与数据分析》9.4.3节
%
% See also RAvarUpdate, raplot, avar.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 21/03/2018
    n = length(r0);
    if ~exist('rmax', 'var'), rmax = 10*r0; end
    if ~exist('rmin', 'var'), rmin = 0.1*r0; end
    if ~exist('maxCount0', 'var'), maxCount0 = 2; end
    if length(tau)==1, tau = repmat(tau, n,1);  end
    if length(rmax)==1, rmax = repmat(rmax, n,1);  end
    if length(rmin)==1, rmin = repmat(rmin, n,1);  end
    ra.tau = tau;
    ra.r0 = r0;
    ra.R = r0.^2;
    ra.Rmax = rmax.^2;
    ra.Rmin = rmin.^2;
    ra.maxCount0 = ones(n,1)*maxCount0;
    ra.maxFlag = ra.maxCount0;
