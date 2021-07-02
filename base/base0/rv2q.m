function q = rv2q(rv)
% Convert rotation vector to transformation quaternion.
%
% Prototype: q = rv2q(rv)
% Input: rv - rotation vector
% Output: q - corresponding transformation quaternion, such that
%             q = [ cos(|rv|/2); sin(|rv|/2)/|rv|*rv ]
% 
% See also  q2rv, rv2m, m2rv, a2qua, rotv, qupdt.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 05/02/2009, 22/05/2014
    q = zeros(4,1);
    n2 = rv(1)*rv(1) + rv(2)*rv(2) + rv(3)*rv(3);
    if n2<1.0e-8  % cos(n/2)=1-n2/8+n4/384; sin(n/2)/n=1/2-n2/48+n4/3840
        q(1) = 1-n2*(1/8-n2/384); s = 1/2-n2*(1/48-n2/3840);
    else
        n = sqrt(n2); n_2 = n/2;
        q(1) = cos(n_2); s = sin(n_2)/n;
    end
    q(2) = s*rv(1); q(3) = s*rv(2); q(4) = s*rv(3);
