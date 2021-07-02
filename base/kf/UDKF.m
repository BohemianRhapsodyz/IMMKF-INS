function [U, D, K] = UDKF(U, D, Phi, Tau, Q, H, R)
% UDUT square root Kalman filter.
%
% Prototype: [U, D, K] = UDKF(U, D, Phi, Tau, Q, H, R)
% Inputs: U - unit upper-triangular matrix
%         D - vector representation of diagonal matrix
%         Phi, Tau, Q - system matrix, processing noise distribusion matrix
%              & noise variance (vector representation)
%         H, R - measurement matrix, measurement noise variance
% Outputs: U - unit upper-triangular matrix
%          D - vector representation of diagonal matrix
%          K - Kalman filter gain
%
% See also  chol1, qrmgs.

% Copyright(c) 2009-2016, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 12/11/2016
    n = length(U);
    W = [Phi*U, Tau];   D1 = [D; Q];  % NOTE: D,Q are both vector
    meanD = mean(D)/n*1e-40;
    for j=n:-1:1   % time updating
        D(j) = (W(j,:).*W(j,:))*D1;
        for i=1:(j-1)
            if D(j)<=meanD, U(i,j) = 0;
            else           U(i,j) = (W(i,:).*W(j,:))*D1/D(j);  end
            W(i,:) = W(i,:) - U(i,j)*W(j,:);
        end
    end
    if ~exist('R', 'var'), return; end
    f = (H*U)';  g = D.*f;  afa = f'*g+R;
    for j=n:-1:1   % measurement updating
        afa0 = afa - f(j)*g(j); lambda = -f(j)/afa0;
        D(j) = afa0/afa*D(j);   afa = afa0;
        for i=1:(j-1)
            s = (i+1):(j-1);
            U(i,j) = U(i,j) + lambda*(g(i)+U(i,s)*g(s));
        end
    end
    K = U*(D.*(H*U)')/R;