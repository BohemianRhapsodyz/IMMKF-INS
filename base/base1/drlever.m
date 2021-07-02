function dr = drlever(dr, lever)
% DR lever arm monitoring or compensation.
%
% Prototype: dr = drlever(dr, lever)
% Inputs: dr - DR structure array created by function 'drinit'
%         lever - lever arms, each column stands for a monitoring point
% Output: dr - DR structure array with lever arm parameters
%
% See also  drinit, drupdate, inslever.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 17/05/2017
    if nargin<2, lever = dr.lever;  end
    dr = inslever(dr, lever);
