function vn = pp2vn(pos0, pos1, ts)
% Use differential positions to get average velocity.
% Denoted as vn = (pos1-pos0)/ts.
%
% Prototype: vn = pp2vn(pos0, pos1, ts)
% Inputs: pos0, pos1 - geographic position at time t0 and t1
%         ts - time interval between t0 and t1, i.e. ts = t1-t0
% Output: vn - average velocity
%
% See also  vn2dpos, p2cne.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 03/10/2013, 10/1/2019
global glv
    if nargin==1
        vn = pos0; vn(1,1:3) = 0;
        for k=2:size(pos0,1)
            vn(k,1:3) = pp2vn(pos0(k-1,1:3), pos0(k,1:3), pos0(k,4)-pos0(k-1,4));
        end
        return;
    end
    if nargin<3
        ts = 1;
    end
    sl=sin(pos0(1)); cl=cos(pos0(1)); sl2=sl*sl;
    sq = 1-glv.e2*sl2; sq2 = sqrt(sq);
    RMh = glv.Re*(1-glv.e2)/sq/sq2+pos0(3);
    RNh = glv.Re/sq2+pos0(3);    clRNh = cl*RNh;
    vn = pos1 - pos0;
    vn = [vn(2)*clRNh; vn(1)*RMh; vn(3)] / ts;