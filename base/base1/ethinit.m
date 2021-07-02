function eth = ethinit(pos, vn)
% The Earth related parameters (structure array) initialization.
%
% Prototype: eth = ethinit(pos, vn)
% Inputs: pos - geographic position [lat;lon;hgt]
%         vn - velocity
% Outputs: eth - parameter structure array
%
% See also  ethupdate, earth.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 23/05/2014
global glv
    if nargin<2,  vn = [0; 0; 0];  end
    if nargin<1,  pos = [0; 0; 0];  end
    eth.Re = glv.Re; eth.e2 = glv.e2; eth.wie = glv.wie; eth.g0 = glv.g0;
    eth = ethupdate(eth, pos, vn);
    eth.wnie = eth.wnie(:);   eth.wnen = eth.wnen(:);
    eth.wnin = eth.wnin(:);   eth.wnien = eth.wnien(:);
    eth.gn = eth.gn(:);       eth.gcc = eth.gcc(:);

