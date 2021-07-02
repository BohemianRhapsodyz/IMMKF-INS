function ins = inslever(ins, lever)
% SINS lever arm monitoring or compensation.
%
% Prototype: ins = inslever(ins, lever)
% Inputs: ins - SINS structure array created by function 'insinit'
%         lever - lever arms, each column stands for a monitoring point
% Output: ins - SINS structure array with lever arm parameters
%
% See also  insinit, insupdate, insextrap.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 29/10/2014
    if nargin<2, lever = ins.lever;  end
    ins.CW = ins.Cnb*askew(ins.web);
    ins.MpvCnb = ins.Mpv*ins.Cnb;
    ins.Mpvvn = ins.Mpv*ins.vn;
    n = size(lever,2);
    if n>1,
        ins.vnL = repmat(ins.vn,1,n) + ins.CW*lever;
        ins.posL = repmat(ins.pos,1,n) + ins.MpvCnb*lever;
    else  % else n==1, the following code is faster
        ins.vnL = ins.vn + ins.CW*lever;
        ins.posL = ins.pos + ins.MpvCnb*lever;
    end
