function xy = gkprj(gk, BL, lgiCenter)
% Gauss-Kruger projection.
%
% Prototype: gk = gkprj(gk, BL)
% Inputs: gk - Gauss-Kruger projection initialization array using gkpinit()
%         BL - [latitude; longitude] in rad
%         lgiCenter - central meridian in rad
% Output: xy - xy coordinate
%
% See also  gkpinit, gkpinv.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 21/05/2017
global glv
    if nargin==3
        stripNo = 0;
        BL(2) = BL(2) - lgiCenter;
    else
        stripNo = floor(BL(2)/glv.deg/6)+1;
        BL(2) = BL(2)-(stripNo*6-3)*glv.deg;
    end
    
	B = BL(1); l = BL(2);
    lB = (B+sin(2*(1:4)*B)*gk.cp(2:5))*gk.cp(1);
	
    cB = cos(B); cBk = cB.^(1:8);
    t = tan(B); tk = t.^(1:6);
    lk = l.^(1:8);
	eta2 = glv.ep2*cBk(2); eta4 = eta2*eta2;
	sB = sin(B);
	N = glv.Re/sqrt(1-glv.e2*sB*sB);
	
	x = lB + t/2*N*cBk(2)*lk(2) + t/24*N*cBk(4)*(5-tk(2)+9*eta2+4*eta4)*lk(4) ...
		+ t/720*N*cBk(6)*(61+58*tk(2)+tk(4)+270*eta2-330*tk(2)*eta2)*lk(6) ...
		+ t/40320*N*cBk(8)*(1385-3111*tk(2)+543*tk(4)-tk(6))*lk(8);
	y = N*cB*l + 1./6*N*cBk(3)*(1-tk(2)+eta2)*lk(3) ...
		+ 1./120*N*cBk(5)*(5+18*tk(2)+tk(4)+14*eta2-58*tk(2)*eta2)*lk(5) ...
		+ 1./5040*N*cBk(7)*(61-479*tk(2)+179*tk(4)-tk(6))*lk(7);
    xy = [x; y+stripNo*1.0e6+5.0e5];
    if length(BL)==3, xy(3) = BL(3); end

