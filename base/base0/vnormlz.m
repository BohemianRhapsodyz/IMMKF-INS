function vec = vnormlz(vec)
% Vector normalization, so ||vec||=1.
%
% Prototype: vec = vnormlz(vec)
% Input: vec - input vector whose norm may not be 1
% Output: vec - input vector whose norm equals 1
%
% See also  mnormlz, qnormlz.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 23/09/2012
    vec = vec/norm(vec);