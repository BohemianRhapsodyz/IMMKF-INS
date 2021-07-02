function qnb1 = qupdt2(qnb0, rv_ib, rv_in)
% Attitude quaternion updating using rotation vector.
% 
% Prototype: qnb1 = qupdt2(qnb0, rv_ib, rv_in)
% Inputs: qnb0 - input quaternion
%         rv_ib - roation vector of b-frame with respect to i-frame
%         rv_in - roation vector of n-frame with respect to i-frame
% Output: qnb1 - output quaternion, 
%                such that qnb1 = rv2q(-rv_in)*qnb0*rv2q(rv_ib)
%
% See also  qupdt, mupdt, qmul, rv2q, lq2m.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 22/05/2014

	% rv2q(rv_ib)
    n2 = rv_ib(1)*rv_ib(1)+rv_ib(2)*rv_ib(2)+rv_ib(3)*rv_ib(3);
    if n2<1.0e-8
        rv_ib0 = 1-n2*(1/8-n2/384); s = 1/2-n2*(1/48-n2/3840);
    else
        n = sqrt(n2); n_2 = n/2;
        rv_ib0 = cos(n_2); s = sin(n_2)/n;
    end
    rv_ib(1) = s*rv_ib(1); rv_ib(2) = s*rv_ib(2); rv_ib(3) = s*rv_ib(3);
    % qnb1 = qmul(qnb0, q);
    qb1 = qnb0(1) * rv_ib0   - qnb0(2) * rv_ib(1) - qnb0(3) * rv_ib(2) - qnb0(4) * rv_ib(3);
    qb2 = qnb0(1) * rv_ib(1) + qnb0(2) * rv_ib0   + qnb0(3) * rv_ib(3) - qnb0(4) * rv_ib(2);
    qb3 = qnb0(1) * rv_ib(2) + qnb0(3) * rv_ib0   + qnb0(4) * rv_ib(1) - qnb0(2) * rv_ib(3);
    qb4 = qnb0(1) * rv_ib(3) + qnb0(4) * rv_ib0   + qnb0(2) * rv_ib(2) - qnb0(3) * rv_ib(1);
    % rv2q(-rv_in)
    n2 = rv_in(1)*rv_in(1)+rv_in(2)*rv_in(2)+rv_in(3)*rv_in(3);
    if n2<1.0e-8
        rv_in0 = 1-n2*(1/8-n2/384); s = -1/2+n2*(1/48-n2/3840);
    else
        n = sqrt(n2); n_2 = n/2;
        rv_in0 = cos(n_2); s = -sin(n_2)/n;
    end
    rv_in(1) = s*rv_in(1); rv_in(2) = s*rv_in(2); rv_in(3) = s*rv_in(3); 
    % qnb1 = qmul(q, qnb1);
    qnb1 = qnb0;    
    qnb1(1) = rv_in0 * qb1 - rv_in(1) * qb2 - rv_in(2) * qb3 - rv_in(3) * qb4;
    qnb1(2) = rv_in0 * qb2 + rv_in(1) * qb1 + rv_in(2) * qb4 - rv_in(3) * qb3;
    qnb1(3) = rv_in0 * qb3 + rv_in(2) * qb1 + rv_in(3) * qb2 - rv_in(1) * qb4;
    qnb1(4) = rv_in0 * qb4 + rv_in(3) * qb1 + rv_in(1) * qb3 - rv_in(2) * qb2;
    % normalization
    n2 = qnb1(1)*qnb1(1)+qnb1(2)*qnb1(2)+qnb1(3)*qnb1(3)+qnb1(4)*qnb1(4);
    if (n2>1.000001 || n2<0.999999)
        nq = 1/sqrt(n2); 
        qnb1(1) = qnb1(1)*nq; qnb1(2) = qnb1(2)*nq; qnb1(3) = qnb1(3)*nq; qnb1(4) = qnb1(4)*nq;
    end


