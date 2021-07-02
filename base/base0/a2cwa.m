function Cwa = a2cwa(att)
% Calculate coefficient matrix in Euler-angle differential equation.
%
% Prototype: Cwa = a2cwa(att)
% Input: att - Euler algles
% Output: Cwa - coefficient matrix, such that w(t) = Cwa*d(att)/d(t)
%              where w(t) is angular velocity
%
% See also  a2caw, a2mat.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 22/03/2008
    si = sin(att(1)); ci = cos(att(1));
    sj = sin(att(2)); cj = cos(att(2));
    Cwa = [  cj, 0, -sj*ci;
             0,  1,  si;
             sj, 0,  cj*ci ];
