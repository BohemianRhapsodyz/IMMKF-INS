function A = setdiag(A, D)
% Replace the diagonals of a matrix with a vector/scale.
%
% Prototype: A = setdiag(A, D)
% Inputs: A - matrix
%         D - new diagonals
% Output: A - diagonals with 'D'
%
% See also  N/A.

% Copyright(c) 2009-2015, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 22/08/2015
    len = length(A);
    D = ones(len,1).*D;
    for k=1:len
        A(k,k) = D(k);
    end
