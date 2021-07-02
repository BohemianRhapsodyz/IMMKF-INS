function c = polyadd(varargin)
% c = a + b + ...
% See also  polycross, polydot, polydotmul, polyintn, polycut.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 21/10/2018
    c = zeros(size(varargin{1},1),1);
    for n=1:nargin
        a = varargin{n};
        sa = size(a,2);  sc = size(c,2);
        clm = abs(sa-sc)+1;
        if sc>=sa, c(:,clm:end) = c(:,clm:end) + a;
        else a(:,clm:end) = a(:,clm:end) + c; c = a; end
    end
