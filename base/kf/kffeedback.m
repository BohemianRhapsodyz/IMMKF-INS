function [kf, ins] = kffeedback(kf, ins, T_fb, fbstring)
% Kalman filter state estimation feedback to SINS.
%
% Prototype: [kf, ins] = kffeedback(kf, ins, T_fb, fbstring)
% Inputs: kf - Kalman filter structure array
%         ins - SINS structure array
%         T_fb - feedback time interval
%         fbstring - feedback tag string
% Outputs: kf, ins - Kalman filter % SINS structure array after feedback
%
% See also  kfinit, kffk, kftypedef.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 05/10/2013
global navtype
    if kf.T_fb~=T_fb
        kf.T_fb = T_fb;
%         kf.coef_fb = (1.0-exp(-kf.T_fb./kf.xtau));
%         kf.coef_fb = ar1coefs(kf.T_fb, kf.xtau);
        xtau = kf.xtau;
    	xtau(kf.xtau<kf.T_fb) = kf.T_fb;  kf.coef_fb = kf.T_fb./xtau;  %2015-2-22
    end
    if nargin>3 % commonly used
        xfb_tmp = kf.coef_fb.*kf.xk;
        for k=1:length(fbstring)
            switch fbstring(k)
                case 'a',
                    idx = 1:3; ins.qnb = qdelphi(ins.qnb, xfb_tmp(idx));
                case 'v',
                    idx = 4:6; ins.vn = ins.vn - xfb_tmp(idx);
                case 'p',
                    idx = 7:9; ins.pos = ins.pos - xfb_tmp(idx);
                case 'e',
                    idx = 10:12; ins.eb = ins.eb + xfb_tmp(idx);
                case 'd',
                    idx = 13:15; ins.db = ins.db + xfb_tmp(idx);
                case 'A',
                    idx = 1:2; ins.qnb = qdelphi(ins.qnb, [xfb_tmp(idx);0]);
                case 'V',
                    idx = 6; ins.vn(3) = ins.vn(3) - xfb_tmp(idx);
                case 'P',
                    idx = 9; ins.pos(3) = ins.pos(3) - xfb_tmp(idx);
                case 'E',
                    idx = 10:11; ins.eb(1:2) = ins.eb(1:2) + xfb_tmp(idx);
                case 'D',
                    idx = 15; ins.db(3) = ins.db(3) + xfb_tmp(idx);
                case 'L',
                    idx = 16:18; ins.lever = ins.lever + xfb_tmp(idx);
                case 'T',
                    idx = 19; ins.tDelay = ins.tDelay + xfb_tmp(idx);
                case 'G',
                    idx = 20:28; dKg = xfb_tmp(idx);  dKg = [dKg(1:3),dKg(4:6),dKg(7:9)];
                    ins.Kg = (eye(3)-dKg)*ins.Kg;
                case 'C',
                    idx = 29:34; dKa = xfb_tmp(idx);  dKa = [dKa(1:3),[0;dKa(4:5)],[0;0;dKa(6)]];
                    ins.Ka = (eye(3)-dKa)*ins.Ka;
                case 'H',
                    idx = [6,9,15];                         ins.vn(3) = ins.vn(3) - xfb_tmp(6);
                    ins.pos(3) = ins.pos(3) - xfb_tmp(9);	ins.db(3) = ins.db(3) + xfb_tmp(15);
                otherwise,
                    error('feedback string mismatch in kf_feedback');
            end
            kf.xk(idx) = kf.xk(idx) - xfb_tmp(idx);    %
            kf.xfb(idx) = kf.xfb(idx) + xfb_tmp(idx);  % record total feedback
        end
        [ins.qnb, ins.att, ins.Cnb] = attsyn(ins.qnb);
        ins.avp = [ins.att; ins.vn; ins.pos];  % 2015-2-22
        return;
    end
    switch(navtype.curtype) % for specail feedback, add code here
        case navtype.xxx,
            NA;
        otherwise,
            error('navtype mismatch in kf_feedback');
    end
 