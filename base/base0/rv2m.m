function m = rv2m(rv)
% Convert rotation vector to transformation matrix.
%
% Prototype: m = rv2m(rv)
% Input: rv - rotation vector
% Output: m - corresponding DCM, such that
%     m = I + sin(|rv|)/|rv|*(rvx) + [1-cos(|rv|)]/|rv|^2*(rvx)^2
%     where rvx is the askew matrix or rv.
% 
% See also  m2rv, rv2q, q2rv, a2mat, rotv.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 05/02/2009, 22/05/2014
	xx = rv(1)*rv(1); yy = rv(2)*rv(2); zz = rv(3)*rv(3);
	n2 = xx+yy+zz;
    if n2<1.e-8
        a = 1-n2*(1/6-n2/120); b = 0.5-n2*(1/24-n2/720);  % a->1, b->0.5
    else
        n = sqrt(n2);
        a = sin(n)/n;  b = (1-cos(n))/n2;
    end
	arvx = a*rv(1);  arvy = a*rv(2);  arvz = a*rv(3);
	bxx = b*xx;  bxy = b*rv(1)*rv(2);  bxz = b*rv(1)*rv(3);
	byy = b*yy;  byz = b*rv(2)*rv(3);  bzz = b*zz;
	m = zeros(3,3);
	% m = I + a*(rvx) + b*(rvx)^2;
	m(1)=1     -byy-bzz; m(4)= -arvz+bxy;     m(7)=  arvy+bxz;
	m(2)=  arvz+bxy;     m(5)=1     -bxx-bzz; m(8)= -arvx+byz;
	m(3)= -arvy+bxz;     m(6)=  arvx+byz;     m(9)=1     -bxx-byy;

