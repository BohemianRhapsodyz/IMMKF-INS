function A = chol1(P)
% Cholesky factorization.
% See also  chol.

% Copyright(c) 2009-2016, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 12/02/2016
    n = length(P);
    A = zeros(n);
    for i=1:n
        for j=1:i-1
            A(i,j) = (P(i,j)-A(i,1:j-1)*A(j,1:j-1)')/A(j,j);
        end
        A(i,i) = sqrt(P(i,i)-A(i,1:i-1)*A(i,1:i-1)');
    end
