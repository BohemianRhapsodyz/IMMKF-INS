function afa = qq2afa(qpb, qnb)
% It's Denoted as 'afa = qpb - qnb', but afa can be large misalignment
% angles. Please refer to 'qq2phi'.
% 
% Prototype: afa = qq2afa(qpb, qnb)
% Inputs: qpb - attitude quaternion from body-frame to computed nav-frame
%         qnb - attitude quaternion from body-frame to ideal nav-frame
% Output: afa - platform misalignment angles between ideal nav-frame and
%               computed nav-frame
%
% See also  qaddphi, qdelphi, qq2phi, qaddphi, qdelafa

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 31/03/2008
    dQ = qmul(qnb, qconj(qpb));
    afa = q2att(dQ);
