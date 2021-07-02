function Ft = etm(ins)
% SINS Error Transition Matrix (see my PhD dissertation p39)
%
% Prototype: Ft = etm(ins)
% Input: ins - SINS structrue array
% Output: Ft - 15x15 error transition matrix
%
% See also  kffk, kfc2d, kfupdate, insupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 27/08/2011, 02/02/2015
	tl = ins.eth.tl; secl = 1/ins.eth.cl;
    f_RMh = 1/ins.eth.RMh; f_RNh = 1/ins.eth.RNh; f_clRNh = 1/ins.eth.clRNh;
    f_RMh2 = f_RMh*f_RMh;  f_RNh2 = f_RNh*f_RNh;
    vn = ins.vn;
    vE_clRNh = vn(1)*f_clRNh; vE_RNh2 = vn(1)*f_RNh2; vN_RMh2 = vn(2)*f_RMh2;
    O33 = zeros(3);
%     Mp1 = [ 0,               0, 0;
%            -ins.eth.wnie(3), 0, 0;
%             ins.eth.wnie(2), 0, 0 ];
    Mp1=O33; Mp1(2)=-ins.eth.wnie(3); Mp1(3)=ins.eth.wnie(2);
%     Mp2 = [ 0,             0,  vN_RMh2;
%             0,             0, -vE_RNh2;
%             vE_clRNh*secl, 0, -vE_RNh2*tl];
    Mp2=O33; Mp2(3)=vE_clRNh*secl; Mp2(7)=vN_RMh2; Mp2(8)=-vE_RNh2; Mp2(9)=-vE_RNh2*tl;
%     Avn = [ 0,    -vn(3), vn(2);                               % Avn = askew(vn);
%             vn(3), 0,    -vn(1);
%            -vn(2), vn(1), 0 ];
    Avn=O33; Avn(2)=vn(3); Avn(3)=-vn(2); Avn(4)=-vn(3); Avn(6)=vn(1); Avn(7)=vn(2); Avn(8)=-vn(1); 
%     Awn = [ 0,               -ins.eth.wnien(3), ins.eth.wnien(2); % Awn = askew(ins.eth.wnien);
%             ins.eth.wnien(3), 0,               -ins.eth.wnien(1); 
%            -ins.eth.wnien(2), ins.eth.wnien(1), 0 ];
    Awn=O33; Awn(2)=ins.eth.wnien(3); Awn(3)=-ins.eth.wnien(2); Awn(4)=-ins.eth.wnien(3); Awn(6)=ins.eth.wnien(1); Awn(7)=ins.eth.wnien(2); Awn(8)=-ins.eth.wnien(1); 
    %%
%     Maa = [ 0,               ins.eth.wnin(3),-ins.eth.wnin(2);  % Maa = -askew(ins.eth.wnin);
%            -ins.eth.wnin(3), 0,               ins.eth.wnin(1); 
%             ins.eth.wnin(2),-ins.eth.wnin(1), 0 ];
    Maa=O33; Maa(2)=-ins.eth.wnin(3); Maa(3)=ins.eth.wnin(2); Maa(4)=ins.eth.wnin(3); Maa(6)=-ins.eth.wnin(1); Maa(7)=-ins.eth.wnin(2); Maa(8)=ins.eth.wnin(1); 
%     Mav = [ 0,       -f_RMh, 0;
%             f_RNh,    0,     0;
%             f_RNh*tl, 0,     0 ];
    Mav=O33; Mav(2)=f_RNh; Mav(3)=f_RNh*tl; Mav(4)=-f_RMh;
    Map = Mp1+Mp2;
%     Mva = [ 0,        -ins.fn(3), ins.fn(2);                    % Mva = askew(ins.fn);
%             ins.fn(3), 0,        -ins.fn(1);
%            -ins.fn(2), ins.fn(1), 0 ];
    Mva=O33; Mva(2)=ins.fn(3); Mva(3)=-ins.fn(2); Mva(4)=-ins.fn(3); Mva(6)=ins.fn(1); Mva(7)=ins.fn(2); Mva(8)=-ins.fn(1); 
    Mvv = Avn*Mav - Awn;
    Mvp = Avn*(Mp1+Map);
    % g = g0*(1+5.27094e-3*eth.sl2+2.32718e-5*sl4)-3.086e-6*pos(3);
    g0 = 9.7803267714;  scl = ins.eth.sl*ins.eth.cl;
    Mvp(3) = Mvp(3)-g0*(5.27094e-3*2*scl+2.32718e-5*4*ins.eth.sl2*scl); Mvp(9) = Mvp(9)+3.086e-6;  % 26/05/2014, good!!!
%     Mpv = [ 0,       f_RMh, 0;
%             f_clRNh, 0,     0;
%             0,       0,     1 ];
    Mpv = ins.Mpv;
%     Mpp = [ 0,           0, -vN_RMh2;
%             vE_clRNh*tl, 0, -vE_RNh2*secl;
%             0,           0,  0 ];
    Mpp = O33; Mpp(2)=vE_clRNh*tl; Mpp(7)=-vN_RMh2; Mpp(8)=-vE_RNh2*secl;
	%%     fi     dvn    dpos    eb       db
	Ft = [ Maa    Mav    Map    -ins.Cnb  O33 
           Mva    Mvv    Mvp     O33      ins.Cnb 
           O33    Mpv    Mpp     O33      O33
           zeros(6,9)  diag(-1./[ins.tauG;ins.tauA]) ];
