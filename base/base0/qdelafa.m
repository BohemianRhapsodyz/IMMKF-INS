function qnb = qdelafa(qpb, afa)
% It's Denoted as 'qnb = qpb - afa', but afa can be large misalignment
% angles. Please refer to 'qdelphi'.
%
% Prototype: qnb = qdelafa(qpb, afa)
% Inputs: qpb - attitude quaternion from body-frame to computed nav-frame
%         afa - platform misalignment angles between ideal nav-frame and
%               computed nav-frame
% Output: qnb - attitude quaternion from body-frame to ideal nav-frame
%
% See also  qaddphi, qdelphi, qq2phi, qaddafa, qq2afa

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 31/03/2008
    qnb = qmul(a2qua(afa), qpb);