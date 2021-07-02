function att = attinterp(att1, att2, ratio)
% Attitude linear interpolation. 
% It can be denoted as att = att1+(att2-att1)*ratio
%
% Prototype: att = attinterp(att1, att2, ratio)
% Inputs: att1,att2 - input Euler angles(or quaternion) at time 1 & 2 
%         ratio - interpolated time ratio point
% Output: att - interpolated Euler angles(or quaternion)
%
% See also  avpinterp, qq2phi, qaddphi, q2att.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 12/02/2014
    if nargin==2  % default half ratio
        ratio = 0.5;
    end
    if length(att1)==3
        qnb1 = a2qua(att1); qnb2 = a2qua(att2);
        phi = qq2phi(qnb2, qnb1);
        qnb = qaddphi(qnb1, phi*ratio);
        att = q2att(qnb);
    else % qnb = attinterp(qnb1, qnb2, ratio)
        qnb1 = att1; qnb2 = att2;
        phi = qq2phi(qnb2, qnb1);
        qnb = qaddphi(qnb1, phi*ratio);
        att = qnb;
    end