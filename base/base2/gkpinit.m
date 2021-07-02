function gk = gkpinit()
% Gauss-Kruger projection initialization.
%
% Prototype: gk = gkpinit()
% Output: gk - initialization array
%
% See also  gkprj, gkpinv.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 21/05/2017
    global glv
    a = glv.Re; b = glv.Rp;
    gk.cp = zeros(6,1); gk.cn = gk.cp;  nk = gk.cp;
    nk = ((a-b)/(a+b)).^(1:5);
	gk.cp(1) = (a+b)/2*(1+1./4*nk(2)+1./64*nk(4));
	gk.cp(2) = -3./2*nk(1)+9./16*nk(3)-3./32*nk(5);
	gk.cp(3) = 15./16*nk(2)-15./32*nk(4);
	gk.cp(4) = -35./48*nk(3)+105./256*nk(5);
	gk.cp(5) = 315./512*nk(4);
	gk.cn(1) = (a+b)/2*(1+1./4*nk(2)+1./64*nk(4));
	gk.cn(2) = 3./2*nk(1)-27./32*nk(3)+269./512*nk(5);
	gk.cn(3) = 21./16*nk(2)-55./32*nk(4);
	gk.cn(4) = 151./96*nk(3)-417./128*nk(5);
	gk.cn(5) = 1097./512*nk(4);

