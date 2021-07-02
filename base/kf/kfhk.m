function Hk = kfhk(ins, varargin)
% Establish Kalman filter measurement matrix.
%
% Prototype: Hk = kfhk(ins, varargin)
% Inputs: ins - SINS structure array from function 'insinit'
%         varargin - if any other parameters
% Output: Hk - measurement matrix
%
% See also  kffk, kfinit, kfupdate, kfc2d, insupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 27/03/2014, 02/02/2015
global psinsdef
    switch(psinsdef.kfhk)
        case 152,
            Hk = [zeros(2,6), eye(2,3), zeros(2,6)];
        case 153,
            Hk = [zeros(3,6), eye(3), zeros(3,6)];
        case 183 % glv.psinsdef.kfhkxx3
            Hk = [zeros(3,6), eye(3), zeros(3,6), -ins.MpvCnb];
        case 193 % glv.psinsdef.kfhkxx3
            Hk = [zeros(3,6), eye(3), zeros(3,6), -ins.MpvCnb, -ins.Mpvvn];
        case 343 % glv.psinsdef.kfhkxx3
            Hk = [zeros(3,6), eye(3), zeros(3,6), -ins.MpvCnb, -ins.Mpvvn, zeros(3,15)];
        case 373
            Hk = [zeros(3,6), eye(3), zeros(3,6), -ins.MpvCnb, -ins.Mpvvn, zeros(3,18)];
        case 156
            Hk = [zeros(6,3), eye(6), zeros(6,6)];
        case 186
            Hk = [zeros(6,3), eye(6), zeros(6,6), [-ins.CW;-ins.MpvCnb]];
        case 196
            Hk = [zeros(6,3), eye(6), zeros(6,6), [-ins.CW,-ins.an;-ins.MpvCnb,-ins.Mpvvn]];
        case 346
            Hk = [zeros(6,3), eye(6), zeros(6,6), [-ins.CW,-ins.an;-ins.MpvCnb,-ins.Mpvvn], zeros(6,15)];
        case 376
            Hk = [zeros(6,3), eye(6), zeros(6,6), [-ins.CW,-ins.an;-ins.MpvCnb,-ins.Mpvvn], zeros(6,15), [-eye(3);zeros(3)]];
%         case {186, 196, 346} % glv.psinsdef.kfhkxx6
%             Hk = [zeros(6,3), eye(6), zeros(6,fix(psinsdef.kfhk/10)-9)];
%             Hk(1:3,16:19) = [-ins.CW, -ins.an];
%             Hk(4:6,16:19) = [-ins.MpvCnb, -ins.Mpvvn];
%         case 376
%             Hk = [zeros(6,3), eye(6), zeros(6,fix(psinsdef.kfhk/10)-9)];
%             Hk(1:3,[16:19,35:37]) = [-ins.CW, -ins.an, -eye(3)];
%             Hk(4:6,16:19) = [-ins.MpvCnb, -ins.Mpvvn];
        otherwise,
        	Hk = feval(psinsdef.typestr, psinsdef.kfhktag, [{ins},varargin]);
    end

