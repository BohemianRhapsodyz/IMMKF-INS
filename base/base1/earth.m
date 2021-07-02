function eth = earth(pos, vn)
% Calculate the Earth related parameters.
%
% Prototype: eth = earth(pos, vn)
% Inputs: pos - geographic position [lat;lon;hgt]
%         vn - velocity
% Outputs: eth - parameter structure array
%
% See also  ethinit, ethupdate, insupdate, trjsimu, etm.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 02/06/2009
global glv
    if nargin==1,  vn = [0; 0; 0];  end
    eth = glv.eth;  % allocate memory ?!
    eth.pos = pos;  eth.vn = vn;
    eth.sl = sin(pos(1));  eth.cl = cos(pos(1));  eth.tl = eth.sl/eth.cl; 
    eth.sl2 = eth.sl*eth.sl;  sl4 = eth.sl2*eth.sl2;
    sq = 1-glv.e2*eth.sl2;  sq2 = sqrt(sq);
    eth.RMh = glv.Re*(1-glv.e2)/sq/sq2+pos(3);
    eth.RNh = glv.Re/sq2+pos(3);  eth.clRNh = eth.cl*eth.RNh;
    eth.wnie = [0; glv.wie*eth.cl; glv.wie*eth.sl];
    vE_RNh = vn(1)/eth.RNh;
    eth.wnen = [-vn(2)/eth.RMh; vE_RNh; vE_RNh*eth.tl];
    eth.wnin = eth.wnie + eth.wnen;
    eth.wnien = eth.wnie + eth.wnin;
    eth.g = glv.g0*(1+5.27094e-3*eth.sl2+2.32718e-5*sl4)-3.086e-6*pos(3); % grs80
    eth.gn = [0;0;-eth.g];
%     eth.gcc = eth.gn - cros(eth.wnien,vn); % Gravitational/Coriolis/Centripetal acceleration
    eth.gcc =  [ eth.wnien(3)*vn(2)-eth.wnien(2)*vn(3);  % faster than previous line
                 eth.wnien(1)*vn(3)-eth.wnien(3)*vn(1);
                 eth.wnien(2)*vn(1)-eth.wnien(1)*vn(2)+eth.gn(3) ];
    