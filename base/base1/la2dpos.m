function dpos = la2dpos(att, pos, la)
% Convert lever arm expressed in body frame to position difference, 
% such as the case between SIMU and GPS.
%
% Prototype: dpos = la2dpos(att, pos, la)
% Inputs: att - SIMU attitude
%         pos - SIMU or GPS position
%         la - levar arm, always using SIMU as coordinate origin
% Output: dpos - position diference
%
% See also  vn2dpos, earth.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 27/08/2013
global glv
    if nargin==2  % la2dpos(avp, la)
        la = pos; pos = att(7:9); att = att(1:3);
    end
    sl=sin(pos(1)); cl=cos(pos(1)); sl2=sl*sl;
    sq = 1-glv.e2*sl2; sq2 = sqrt(sq);
    RMh = glv.Re*(1-glv.e2)/sq/sq2+pos(3);
    RNh = glv.Re/sq2+pos(3);    clRNh = cl*RNh;
    ln = a2mat(att)*la;
    dpos = [ln(2)/RMh; ln(1)/clRNh; ln(3)];
