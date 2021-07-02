function p = polycut(p, m0)
% See also  polycross, polydot, polyadd, polydotmul, polyintn.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 21/10/2018
    [n, m] = size(p);
    if m>m0
        p = p(:,end-(m0-1):end);
    else
        p = [zeros(n,m0-m),p];
    end

