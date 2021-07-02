function [U, D] = UDUT(P)
% UDUT decomposition, so that P = U*diag(D)*U'.
%
% Prototype: [U, D] = UDUT(P)
% Input: P - nonnegative define symmetic matrix
% Outputs: U - unit upper-triangular matrix 
%          D - vector representation of diagonal matrix
%
% See also  chol1, qrmgs.

% Copyright(c) 2009-2016, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 12/11/2016
    n = length(P);
    U = eye(n); D = zeros(n,1);  trPn = trace(P)/n*1e-40;
    for j=n:-1:1
        k = (j+1):n;
        D(j) = P(j,j) - (U(j,k).^2)*D(k);
        if D(j)<=trPn, continue; end
        for i=(j-1):-1:1
            U(i,j) = (P(i,j)-(U(i,k).*U(j,k))*D(k)) / D(j);
        end
    end