function qpb = qaddafa(qnb, afa)
% It's Denoted as 'qpb = qnb + afa', but afa can be large misalignment
% angles. Please refer to 'qaddphi'.
%
% Prototype: qpb = qaddafa(qnb, afa)
% Inputs: qnb - attitude quaternion from body-frame to ideal nav-frame
%         afa - platform misalignment angles between ideal nav-frame and
%               computed nav-frame
% Output: qpb - attitude quaternion from body-frame to computed nav-frame
%
% See also  qaddphi, qdelphi, qq2phi, qdelafa, qq2afa

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 31/03/2008
%     qpb = qmul(rv2q(-phi),qnb);
    qpb = qmul(qconj(a2qua(afa)), qnb);
