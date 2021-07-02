function Cnb = mnormlz(Cnb)
% Matrix normalization, so ||Cnb||=1.
%
% Prototype: Cnb = mnormlz(Cnb)
% Input: Cnb - input 3x3 matirx whose norm may not be 1
% Output: Cnb - input 3x3 matirx whose norm equals 1
%
% See also  vnormlz, qnormlz.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 23/09/2012
    for k=1:5
%         Cnb = 0.5 * (Cnb + (Cnb')^-1);  % Algorithm 1 
        Cnb = 1.5*Cnb - 0.5*(Cnb*Cnb')*Cnb;  % Algorithm 2 
    end
    
%   Algorithm 3:  [s,v,d] = svd(Cnb); Cnb = s*d';  % in = s*v*d' = s*d' * d*v*d';  out = s*d'