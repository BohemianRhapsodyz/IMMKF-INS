function ap = apscale(ap, idx, ratio)
% Enlage trajectory ap0(idx(1):idx(2),4:7), including position and time
% scale by ratio.
%
% See also  apmove, avp2imu.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 17/03/2014
    ap(:,1:3) = att2c(ap(:,1:3));
    if length(idx)==2,  idx = (idx(1):idx(2))';  end
    ts = ap(idx(1)+1,7) - ap(idx(1),7);
    len = length(idx);
    ratio = fix(len*ratio)/len;
    rts = ratio*ts;
    ap1 = ap(1:idx(1)-1,:);      % phase 1
    ap2 = ap(idx,:);             % phase 2
    ap2(:,7) = ap2(1,7)+(0:len-1)'*rts;  % enlage time
    for k=4:6
        ap2(:,k) = ap2(1,k)+ratio*(ap2(:,k)-ap2(1,k)); % enlage pos
    end
    t = (ap2(1,7):ts:(ap2(end,7)+ts/10))';  % resampling time points
    ap2i = [zeros(length(t),6),t];
    for k=1:6  % resampling att & pos
        ap2i(:,k) = interp1(ap2(:,7),ap2(:,k),ap2i(:,7));
    end
    ap3 = ap(idx(end)+1:end,:);   % phase 3
    for k=4:7
        ap3(:,k) = ap3(:,k)-ap(idx(end),k)+ap2i(end,k);
    end
    ap = [ap1; ap2i; ap3]; % ap1 & ap3 remain unchanged