function [Phikk_1, Qk] = kfc2d(Ft, Qt, Ts, n)
% For Kalman filter system differential equation, convert continuous-time
% model to discrete-time model: Ft->Phikk_1, Qt->Qk.
%
% Prototype: [Phikk_1, Qk] = kfc2d(Ft, Qt, Ts, n)
% Inputs: Ft - continous-time system transition matrix
%         Qt - continous-time system noise variance matrix
%         Ts - discretization time interval
%         n - the order for Taylor expansion
% Outputs: Phikk_1 - discrete-time transition matrix
%          Qk - discrete-time noise variance matrix
% Alogrithm notes:
%    Phikk_1 = I + Ts*Ft + Ts^2/2*Ft^2 + Ts^3/6*Ft^3 
%                + Ts^4/24*Ft^4 + Ts^5/120*Ft^5 + ...
%    Qk = M1*Ts + M2*Ts^2/2 + M3*Ts^3/6 + M4*Ts^4/24 + M5*Ts^5/120 + ...
%    where M1 = Qt; M2 = Ft*M1+(Ft*M1)'; M3 = Ft*M2+(Ft*M2)';
%          M4 = Ft*M3+(Ft*M3)'; M5 = Ft*M4+(Ft*M4)'; ...
%
% See also  kfinit, kffk, kfupdate, kffeedback.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 05/08/2012
    Phikk_1 = eye(size(Ft)) + Ts*Ft;
    Qk = Qt*Ts;
    if nargin<4 % n==1
        return;
    end
    Tsi = Ts; facti = 1; Fti = Ft; Mi = Qt;
    for i=2:1:n
        Tsi = Tsi*Ts;        
        facti = facti*i;
        Fti = Fti*Ft;
        Phikk_1 = Phikk_1 + Tsi/facti*Fti;  % Phikk_1
        FtMi = Ft*Mi;
        Mi = FtMi + FtMi';
        Qk = Qk + Tsi/facti*Mi;  % Qk
    end    