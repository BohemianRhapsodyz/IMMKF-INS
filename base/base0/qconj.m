function qo = qconj(qi)
% Quaternion conjugation.
% 
% Prototype: qo = qconj(qi)
% Input: qi - input quaternion
% Output: qo - output quaternion ,if qi = [qi(1); qi(2:4)]
%              then qo = [qi(1); -qi(2:4)]
% 
% See also  qmul, qmulv.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 22/11/2007
    qo = [qi(1); -qi(2:4)];