function rv = m2rv2(m)
% Convert transformation matrix to rotation vector.
%
% Prototype: rv = m2rv(m)
% Input: m - transformation matrix
% Output: rv - corresponding rotation vector, such that
%     m = I + sin(|rv|)/|rv|*(rvx) + [1-cos(|rv|)]/|rv|^2*(rvx)^2
%     where rvx is the askew matrix or rv.
% 
% See also  rv2m, rv2q, q2rv, m2att.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 05/02/2009, 18/03/2014

    m1 = m-eye(3);
	rv = [m(3,2); m(1,3); m(2,1)];
    rvx = [ 0,     -rv(3),  rv(2); 
            rv(3),  0,     -rv(1); 
           -rv(2),  rv(1),  0     ];
    for k=1:10
        n2 = rv'*rv; 
        if n2>1.0e-40
            n = sqrt(n2);
            rvx = (m1-(1-cos(n))/n2*rvx*rvx) * (n/sin(n));
            rv = [rvx(3,2); rvx(1,3); rvx(2,1)];
        else
            rv = zeros(3,1);
            break;
        end
    end
