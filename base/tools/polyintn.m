function pi = polyintn(p,k)
% See also  polyvaln, polycross, polydot, polydotmul, polyadd.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 22/10/2018
    if nargin<2, k=0; end
    for n=1:size(p,1)
        pi(n,:) = [p(n,:)./(length(p(n,:)):-1:1) k];
    end