function phi = qq2phi(qpb, qnb)
% Calculate platform misalignment angles between qpb and qnb.
% It can be denoted as 'phi = qpb - qnb', where qpb is caculated  
% quaternion and qnb is accurate quaternion.
%
% Prototype: phi = qq2phi(qpb, qnb)
% Inputs: qpb - attitude quaternion from body-frame to computed nav-frame
%         qnb - attitude quaternion from body-frame to ideal nav-frame
% Output: phi - platform misalignment angles from ideal nav-frame to
%               computed nav-frame: Cnp = I + (phiX)
%
% See also  qaddphi, qdelphi, aa2phi, qaddafa, qdelafa, qq2afa, qq2rv.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 31/03/2008
    dQ = qmul(qnb, qconj(qpb));
    phi = q2rv(dQ);
