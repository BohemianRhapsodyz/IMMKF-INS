function vo = qmulv(q, vi)
% 3x1 vector coordinate transformation by quaternion.
% 
% Prototype: vo = qmulv(q, vi)
% Inputs: q - transformation quaternion
%         vi - vector to be transformed
% Output: vo - output vector, such that vo = q*vi*conjugation(q)
% 
% See also  q2mat, qconj, qmul.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 22/11/2007, 22/05/2014

% method (1): 16*2=32 multiplications
%     qi = [0;vi];
%     qo = qmul(qmul(q,qi),qconj(q));
%     vo = qo(2:4,1);

% method (2): 16+9=25 multiplications
%     vo = q2mat(q)*vi;

% method (3): 12*2=24 multiplications
% q=q*vi where qi(1)==0
    qo1 =              - q(2) * vi(1) - q(3) * vi(2) - q(4) * vi(3);
    qo2 = q(1) * vi(1)                + q(3) * vi(3) - q(4) * vi(2);
    qo3 = q(1) * vi(2)                + q(4) * vi(1) - q(2) * vi(3);
    qo4 = q(1) * vi(3)                + q(2) * vi(2) - q(3) * vi(1);
    vo = vi;
    vo(1) = -qo1 * q(2) + qo2 * q(1) - qo3 * q(4) + qo4 * q(3);
    vo(2) = -qo1 * q(3) + qo3 * q(1) - qo4 * q(2) + qo2 * q(4);
    vo(3) = -qo1 * q(4) + qo4 * q(1) - qo2 * q(3) + qo3 * q(2);
       
%     qo = q;
%     qo(1) =              - q(2) * vi(1) - q(3) * vi(2) - q(4) * vi(3);
%     qo(2) = q(1) * vi(1)                + q(3) * vi(3) - q(4) * vi(2);
%     qo(3) = q(1) * vi(2)                + q(4) * vi(1) - q(2) * vi(3);
%     qo(4) = q(1) * vi(3)                + q(2) * vi(2) - q(3) * vi(1);
%     vo = vi;
%     vo(1) = -qo(1) * q(2) + qo(2) * q(1) - qo(3) * q(4) + qo(4) * q(3);
%     vo(2) = -qo(1) * q(3) + qo(3) * q(1) - qo(4) * q(2) + qo(2) * q(4);
%     vo(3) = -qo(1) * q(4) + qo(4) * q(1) - qo(2) * q(3) + qo(3) * q(2);
