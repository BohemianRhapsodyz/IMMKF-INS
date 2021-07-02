function q = qupdt(q1, rv)
% Attitude quaternion updating using rotation vector.
% 
% Prototype: q = qupdt(q1, rv)
% Inputs: q1 - input quaternion
%         rv - roation vector
% Output: q - output quaternion, such that q = qmul(q1, rv2q(rv))
%
% See also  qupdt2, mupdt, qmul, rv2q, lq2m.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 13/05/2014
    % q2 = rv2q(rv);
    n2 = rv'*rv;
    if n2<1.0e-8  % 1.0e-8
        c = 1-n2*(1/8-n2/384); s = 1/2-n2*(1/48-n2/3840);
    else
        n = sqrt(n2); n_2 = n/2;
        c = cos(n_2); s = sin(n_2)/n;
    end
    q2 = [c; s*rv];    
    % q = qmul(q1, q2);
    q = [ q1(1) * q2(1) - q1(2) * q2(2) - q1(3) * q2(3) - q1(4) * q2(4);
          q1(1) * q2(2) + q1(2) * q2(1) + q1(3) * q2(4) - q1(4) * q2(3);
          q1(1) * q2(3) + q1(3) * q2(1) + q1(4) * q2(2) - q1(2) * q2(4);
          q1(1) * q2(4) + q1(4) * q2(1) + q1(2) * q2(3) - q1(3) * q2(2) ];
    % normalization
    nq2 = q'*q;
    if (nq2>1.000001 || nq2<0.999999)
        q = q/sqrt(nq2);
    end

