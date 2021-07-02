function qnb = qdelphi(qpb, phi)
% Get the accurate quaternion from calculated quaternion and misalignment
% angles. It can be denoted as 'qnb = qpb - phi', where qpb is calculated 
% quaternion and phi is misalignment angles.
%
% Prototype: qnb = qdelphi(qpb, phi)
% Inputs: qpb - attitude quaternion from body-frame to computed nav-frame
%         phi - platform misalignment angles from computed nav-frame to
%               ideal nav-frame
% Output: qnb - attitude quaternion from body-frame to ideal nav-frame
%
% See also  qaddphi, qq2phi, qaddafa, qdelafa, qq2afa.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 31/03/2008
    qnb = qmul(rv2q(phi), qpb);