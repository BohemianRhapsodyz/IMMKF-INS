function c = polydotmul(a, b)
% c = a .* b
% See also  polycross, polydot, polyadd, polyintn, polycut.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 21/10/2018
    [sa, na] = size(a); [sb, nb] = size(b);
    if sa==1, a = repmat(a, sb, 1);
    elseif sb==1, b = repmat(b, sa, 1); end
    c = zeros(max(sa,sb), na+nb-1);
    for k=1:max(sa,sb)
        c(k,:) = conv(a(k,:), b(k,:));
    end

