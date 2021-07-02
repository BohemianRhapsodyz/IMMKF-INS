function BL = gkpinv(gk, xy, lgiCenter)
% Inverse Gauss-Kruger projection.
%
% Prototype: BL = gkpinv(gk, xy, lgiCenter)
% Inputs: gk - Gauss-Kruger projection initialization array using gkpinit()
%         xy - xy coordinate
%         lgiCenter - central meridian in rad
% Output: BL - [latitude; longitude] in rad
%
% See also  gkpinit, gkprj.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 21/05/2017
global glv
    if nargin==3
        stripNo = 0;
    else
        stripNo = floor(xy(2)/1e7);
    end
    xy(2) = xy(2)-stripNo*1.0e6-5.0e5;
    
	x = xy(1); y = xy(2);
	xbar = x/gk.cp(1);
	Bf = xbar + sin(2*(1:4)*xbar)*gk.cn(2:5);
	
	sBf = sin(Bf);
	Nf = glv.Re/sqrt(1-glv.e2*sBf*sBf);
    Nfk = Nf.^(1:8);
	tf = tan(Bf);  tfk = tf.^(1:6);
	cBf = cos(Bf);
	etaf2 = glv.ep2*cBf*cBf; etaf4 = etaf2*etaf2;
    yk = y.^(1:8);
	
	B = Bf + tf/(2*Nfk(2))*(-1-etaf2)*yk(2) ...
		+ tf/(24*Nfk(4))*(5-3*tfk(2)+6*etaf2-6*tfk(2)*etaf2-3*etaf4-9*tfk(2)*etaf4)*yk(4) ...
		+ tf/(720*Nfk(6))*(-61-90*tfk(2)-45*tfk(4)-107*etaf2+162*tfk(2)*etaf2+45*tfk(4)*etaf2)*yk(6) ...
		+ tf/(40320*Nfk(8))*(1385+3633*tfk(2)+4095*tfk(4)+1575*tfk(6))*yk(8);
	l = 1./(Nf*cBf)*y + 1./(6*Nfk(3)*cBf)*(-1-2*tfk(2)-etaf2)*yk(3) ...
		+ 1./(120*Nfk(5)*cBf)*(5-28*tfk(2)+24*tfk(4)*6*etaf2+8*tfk(2)*etaf2)*yk(5) ...
		+ 1./(5040*Nfk(7)*cBf)*(-61-662*tfk(2)-1320*tfk(4)-720*tfk(6))*yk(7);
    if nargin==3
        BL = [B; l+lgiCenter];
    else
        BL = [B; l+(stripNo*6-3)*glv.deg];
    end
    if length(xy)==3, BL(3) = xy(3); end
