function ra = RAvarUpdate(ra, w, ts)
% ����ʱ�����еķ���ο��������������������ݷ�����9.4.3��
%
% See also RAvarInit, raplot, avar.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 21/03/2018
    dr2 = (w-ra.r0).^2;  ra.r0 = w;
    for k=1:length(w)
        if dr2(k)>ra.Rmax(k)
            ra.R(k) = ra.Rmax(k);
            ra.maxFlag(k) = ra.maxCount0(k);
        else
            tstau = min(1, ts/ra.tau(k));
            ra.R(k) = (1-tstau)*ra.R(k) + tstau*dr2(k);
            if ra.R(k)<ra.Rmin(k)
                ra.R(k) = ra.Rmin(k);
            end
            if ra.maxFlag(k)>0
                ra.maxFlag(k) = ra.maxFlag(k) - 1;
            end
        end
    end
    