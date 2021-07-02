function ins = insextrap(ins, dt)
% SINS navigation parameter extrapolation with some time difference.
%
% Prototype: ins = insextrap(ins, dt)
% Inputs: ins - SINS structure array created by function 'insinit'
%         dt - time difference
% Output: ins - SINS structure array
%
% See also  insinit, insupdate, inslever.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 29/10/2014
    ins.attP = q2att(qmul(ins.qnb, rv2q(ins.wnb*dt)));
    ins.vnP = ins.vn + ins.an*dt;
    ins.posP = ins.pos + ins.Mpvvn*dt;