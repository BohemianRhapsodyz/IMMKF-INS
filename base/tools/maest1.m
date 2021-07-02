function [theta, vm] = maest(rho)
% Parameter estimation for MA model. Ref. Tian Zheng P291.
%
% Prototype: [theta, vm] = maest(rho)
% Input: rho - auto-correlation, where rho(1)=1
% Outputs: theta - MA coefficients, 
%          vm - noise
%            x(k) = theta(1)*w(k) + theta(2)*w(k-1) + ... 
%            where w(k)~WN(0,vm)

% See also:  N/A.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 01/11/2014
    
%     rho = [7.5541; -5.1241; 1.3805];
    rho0 = rho(1); rho = rho(2:end);
    n = length(rho);
    v0 = rho0;
    theta = zeros(n,n); v = zeros(n,1);
    for m=1:n
        for k=0:m-1
            s = 0;
            for j=0:k-1
                if j==0, s=s+theta(m,m-j)*theta(k,k-j)*v0;
                else s=s+theta(m,m-j)*theta(k,k-j)*v(j); end
            end
            if k==0, theta(m,m-k) = 1/v0*(rho(m-k)-s);
            else theta(m,m-k) = 1/v(k)*(rho(m-k)-s); end
        end
        s = 0;
        for j=0:m-1
            if j==0, s=s+theta(m,m-j)^2*v0;
            else s=s+theta(m,m-j)^2*v(j); end
        end
        v(m) = v0-s;
    end
    theta = [1; theta(end,:)']; vm = v(end);
