function [blh, Cen] = xyz2blh(xyz)
% Convert ECEF Cartesian coordinate [x;y;z] to geographic
% coordinate [lat;lon;height].
%
% Prototype: [blh, Cen] = xyz2blh(xyz)
% Input: xyz - ECEF Cartesian coordinate vector, in meters 
% Outputs: blh - geographic coordinate blh=[lat;lon;height],
%               where lat & lon in radians and hegtht in meter
%          Cen - transformation matrix from e-frame to n-frame
%
% See also  blh2xyz, pos2cen.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 03/09/2013, 16/07/2015
global glv
    X = xyz(1); Y = xyz(2); Z = xyz(3);
    s = sqrt(X^2+Y^2);
    if s<0.01, X=0.01; Y=0; s = sqrt(X^2+Y^2); end % 30/08/18
    theta = atan2(Z*glv.Re,s*glv.Rp);
    L = atan2(Y,X);
    B = atan2(Z+glv.ep2*glv.Rp*sin(theta)^3, s-glv.e2*glv.Re*cos(theta)^3);
    sB = sin(B); cB = cos(B);
    N = glv.Re/sqrt(1-glv.e2*sB^2);
    H = s/cB-N;
    blh = [B; L; H];
    if nargout==2
        sL = sin(L); cL = cos(L);
        Cen = [-sL, -sB*cL, cB*cL; cL, -sB*sL, cB*sL; 0, cB, sB];
    end