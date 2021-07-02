function blh = xyz2blhN(xyz)
% See also  xyz2blh.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 10/07/2018
global glv
    X = xyz(:,1); Y = xyz(:,2); Z = xyz(:,3);
    s = sqrt(X.^2+Y.^2);
    theta = atan2(Z*glv.Re,s*glv.Rp);
    L = atan2(Y,X);
    B = atan2(Z+glv.ep2*glv.Rp*sin(theta).^3, s-glv.e2*glv.Re*cos(theta).^3);
    sB = sin(B); cB = cos(B);
    N = glv.Re./sqrt(1-glv.e2*sB.^2);
    H = s./cB-N;
    blh = [B, L, H];
