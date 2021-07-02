function m = mupdt(m1, rv)
% Attitude matrix (DCM) updating using rotation vector.
% 
% Prototype: m = mupdt(m1, rv)
% Inputs: m1 - input DCM
%         rv - roation vector
% Output: m - output DCM, such that m = m1*rv2m(rv)
%
% See also  rv2m, qupdt.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 13/05/2014
	xx = rv(1)*rv(1); yy = rv(2)*rv(2); zz = rv(3)*rv(3);
	n2 = xx+yy+zz;
    if n2>1.e-16  % if n=1e-8 then sin(n)/n-1==0, 1-cos(n)==0
        n = sqrt(n2);
        a = sin(n)/n; b = (1-cos(n))/n2;  % n->0, b->0.5
        arv = a*rv;
        bxx = b*xx; bxy = b*rv(1)*rv(2); bxz = b*rv(1)*rv(3);
        byy = b*yy; byz = b*rv(2)*rv(3); bzz = b*zz;
        m = [1,-arv(3),arv(2); arv(3),1,-arv(1); -arv(2),arv(1),1]+...
            [-byy-bzz,bxy,bxz; bxy,-bxx-bzz,byz; bxz,byz,-bxx-byy];
    else
        % a=1, b=0.5, bii->0
        m = [1,-rv(3),rv(2); rv(3),1,-rv(1); -rv(2),rv(1),1];
    end
    % m = m1*rv2m(rv)
    m = m1*m;

