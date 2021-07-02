function Xk = afamodel(Xkk_1, px)
% Large misalignment angle error model(Ref. my postdoctoral report P67).
% The 6-state only includes large Euler angles [afax;afay;afaz] and
% level velocity [dvx; dvy; dvz].
%
% Prototype: Xk = afamodel(Xkk_1, px)
% Inputs: xkk_1 - state at previous time
%         px - includes time-variant parametrs
% Output: Xk - current state
%
% See also  ukf.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 11/02/2009
global glv
    % (afa, vn) = afamodel(afa_1, vn_1, wnin, fn, ts)
    wnin = px(1:3); fn = px(4:6); ts = px(7);
    afa = Xkk_1(1:3);
    Cw = a2cwa(afa);
    Cnn = a2mat(afa);
    afa = afa + Cw^-1*(glv.I33-Cnn')*wnin*ts;
    vn = Xkk_1(4:6) + (glv.I33-Cnn)*fn*ts;
    Xk = [afa; vn];
