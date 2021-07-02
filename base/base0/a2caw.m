function Caw = a2caw(att)
% Calculate coefficient matrix in Euler-angle differential equation.
%
% Prototype: Caw = a2caw(att)
% Input: att - Euler algles
% Output: Caw - coefficient matrix, such that d(att)/d(t) = Caw*w(t)
%              where w(t) is angular velocity
%
% See also  a2cwa, a2mat.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 22/03/2008
    si = sin(att(1)); ci = cos(att(1)); ti = si/ci;
    sj = sin(att(2)); cj = cos(att(2));
    Caw = [  cj,     0,  sj;
             sj*ti,  1, -cj*ti;
            -sj/ci,  0,  cj/ci ];
