function invM = invbc(M)
% An alogrithm for matrix inversion to avoid 'bad condition number' warning.
%
% Prototype: invM = invbc(M)
% Input: M - input square matrix
% Output: invM - the inversion of input M
%
% See also  kfupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 20/01/2014

    D = sqrt(diag(M));
    K = max(D)./D;
    K = diag(K);
    invM = K/(K*M*K)*K;
    return
    
%     D = sqrt(diag(M));
%     K = max(D)./D;
%     K = K*K';
%     invM = K.*inv(K.*M);