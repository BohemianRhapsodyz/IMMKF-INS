function avp = avpinterp(avp1, avp2, ratio)
% avp linear interpolation. 
% It can be denoted as avp = avp1+(avp2-avp1)*ratio
%
% Prototype: avp = avpinterp(avp1, avp2, ratio)
% Inputs: avp1,avp2 - input avp at time 1 & 2
%         ratio - interpolated time ratio point
% Output: avp - interpolated avp
%
% See also  attinterp.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 12/02/2014    
    if nargin==2  % default half ratio
        ratio = 0.5;
    end
    avp = avp1 + (avp2-avp1)*ratio;
    avp(1:3) = attinterp(avp1(1:3), avp2(1:3), ratio);