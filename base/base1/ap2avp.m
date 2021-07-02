function  avp = ap2avp(ap, ts)
% Cubic spline interpolation of ap to generate avp with sampling time ts,
% where the velocity is the differentiation of position.
% Inputs: ap = [att, pos, t]
%         ts - sampling time
% Output: avp = [att, vn, pos, t]
%
% See also  att2c, avp2imu, trjsimu, insupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 15/10/2013, 15/03/2014
    ts0 = ap(2,7)-ap(1,7);
    if nargin<2,  ts = ts0;  end
    t = (ap(1,7):ts:ap(end,7))';
    ap(:,1:3) = att2c(ap(:,1:3)); % make sure att is continuous
    avp = zeros(length(t), 10);
    ap(:,1:3) = att2c(ap(:,1:3));
    for k=1:3  % attitude spline interpolation
        avp(:,k) = spline(ap(:,7), ap(:,k), t);
    end
    for k=1:3
        pp = spline(ap(:,7), ap(:,3+k));
        avp(:,6+k) = ppval(pp, t); % position interpolation
        dpp = pp;
        for kk=1:pp.pieces
            dpp.coefs(kk,:) = [0, [3,2,1].*pp.coefs(kk,1:3)]; % coef differentiation
        end
        avp(:,3+k) = ppval(dpp, t); % velocity interpolation [dlat,dlon,dhtg]
    end
    [RMh, clRNh] = RMRN(avp(:,7:9));
    avp(:,[4,5]) = [avp(:,5).*clRNh, avp(:,4).*RMh]; % [dlat,dlon]->[VE,VN]
    avp(:,10) = t;
%     % velocity integral verify
%     dp = [avp(:,4)./clRNh, avp(:,5)./RMh]; % [dlat,dlon]->[VE,VN]
%     dp = cumint(dp,(avp(2,end)-avp(1,end)), 1);
%     figure, plot(avp(:,end), [avp(:,7)-avp(1,7) - dp(:,2)-dp(1,2)]*glv.Re); grid on
