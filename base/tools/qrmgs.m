function [Q, R] = qrmgs(A)
% Modified Gram-Schmidt orthogonal-triangular decomposition.
% [Q,R] = qrmgs(A), where A is m-by-n, produces an n-by-n upper triangular
% matrix R and an m-by-n unitary matrix Q (Q'*Q=I) so that A = Q*R.
%
% See also  qr.

% Copyright(c) 2009-2015, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 05/11/2015
    [m, n] = size(A);
    if n>m,  error('n must not less than m.'); end
    R = zeros(n);
    for i=1:n
        R(i,i) = sqrt(A(:,i)'*A(:,i));
        if R(i,i)<eps,  A(i,i) = 1; R(:,i) = 0; continue;  end
        A(:,i) = A(:,i)/R(i,i);
        j = i+1:n;
        R(i,j) = A(:,i)'*A(:,j);
        A(:,j) = A(:,j)-A(:,i)*R(i,j);
    end
    Q = A;