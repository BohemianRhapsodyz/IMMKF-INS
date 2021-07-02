function kf = kfupdatesq(kf, yk, measflag)
% KF sequential filtering for measurement update. 
%
% See also  kfupdate.

% Copyright(c) 2009-2015, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 22/02/2015
    if measflag~='M', error('kfupdatesq only used for KF measurement update!\n'); end
    Hk = kf.Hk; Rk = kf.Rk;
    if kf.adaptive==1, m = kf.m; kf.m = 1; Rmin = kf.Rmin; Rmax = kf.Rmax; beta = kf.beta; end
    for k=1:length(yk)
        kf.Hk = Hk(k,:); kf.Rk = Rk(k,k);
        if kf.adaptive==1, kf.Rmin = Rmin(k,k); kf.Rmax = Rmax(k,k); kf.beta = beta; end
        kf = kfupdate(kf, yk(k), 'M');
        if kf.adaptive==1, Rk(k,k) = kf.Rk; end
    end
    if kf.adaptive==1, kf.m = m; kf.Rmin = Rmin; kf.Rmax = Rmax; end
    kf.Hk = Hk; kf.Rk = Rk;
