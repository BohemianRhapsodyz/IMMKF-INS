function [b, sigma2, bm, sigma2m] = maest(gamma)
% Parameter estimation for MA model. Ref. Tian Zheng P291.
%
% Prototype: [b, sigma2, bm, sigma2m] = maest(gamma)
% Input: gamma - auto-correlation sequence
% Outputs: b - MA coefficients
%          sigma2 - noise variance
%            x(k) = w(k) + b(1)*w(k-1) + b(2)*w(k-2)... 
%            where w(k) ~ WN(0,sigma2)

% See also:  N/A.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 01/11/2014
%     gamma = [7.5541; -5.1241; 1.3805];
    gamma0 = gamma(1); gamma = gamma(2:end);
    nq = length(gamma);
    sigma2m0 = gamma0;
    bm = zeros(nq); sigma2m = zeros(nq,1);
    for m=1:nq
        for k=0:m-1
            s = 0;
            for j=0:k-1
                if j==0, s=s+bm(m,m-j)*bm(k,k-j)*sigma2m0;
                else s=s+bm(m,m-j)*bm(k,k-j)*sigma2m(j); end
            end
            if k==0, bm(m,m-k) = 1/gamma0*(gamma(m-k)-s);
            else bm(m,m-k) = 1/sigma2m(k)*(gamma(m-k)-s); end
        end
        s = 0;
        for j=0:m-1
            if j==0, s=s+bm(m,m-j)^2*sigma2m0;
            else s=s+bm(m,m-j)^2*sigma2m(j); end
        end
        sigma2m(m) = gamma0-s;
    end
    b = bm(end,:)'; sigma2 = sigma2m(end);

