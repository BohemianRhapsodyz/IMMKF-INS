function rv = q2rv(q) 
% Convert transformation quaternion to rotation vector.
%
% Prototype: rv = q2rv(q) 
% Input: q - transformation quaternion
% Output: rv - corresponding rotation vector, such that
%              q = [ cos(|rv|/2); sin(|rv|/2)/|rv|*rv ]
% 
% See also  rv2q, qq2rv, qq2phi, m2rv, rv2m, q2att.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 05/02/2009
	if(q(1)<0)
	    q = -q;
	end
    n2 = acos(q(1));
    if n2>1e-40
        k = 2*n2/sin(n2);
    else
        k = 2;
    end
    rv = k*q(2:4);   % q = [ cos(|rv|/2); sin(|rv|/2)/|rv|*rv ];