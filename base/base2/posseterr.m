function dpos = posseterr(dpos0)
% position errors dpos=[dlat;dlon;dhgt] setting.
%
% Prototype: dpos = posseterr(dpos0)
% Input: dpos0=[dlat; dlon; dhgt], NOTE: dlat, dlon and dhgt are all in m.
% Output: dpos=[dpos0(1)/Re; dpos0(2)/Re; dpos0(3)], so dpos(1)=dlat,
%              dpos(2)=dlon are in rad and dpos(3)=dhgt is in m.
% 
% See also  avpseterr, posset.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 09/03/2014
global glv
    dpos0 = dpos0(:);
    if length(dpos0)==1,     dpos0=[dpos0;dpos0;dpos0];
    elseif length(dpos0)==2, dpos0=[dpos0(1);dpos0(1);dpos0(2)];  end
    dpos=[dpos0(1:2)/glv.Re; dpos0(3)];
