function [rho, phi] = apcorr(x, n)
% Plot and return auto-correlation & partial-correlation of time-series
% data 'x'.
%
% Prototype: [rho, phi] = apcorr(x, n)
% Inputs: x - data input, a vector
%         n - correlation order to be computed, 50 is the default.
% Outputs: rho - auto-correlation
%          phi - partial-correlation
% See also:  N/A.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 01/11/2014
    N = length(x); sN = fix(sqrt(N));
    if nargin<2, n = min(50,sN); end
    r = xcorr(x(:)-mean(x),'coeff');
    r = r(N:end);
    phi = [1;pacf(r(2:n))]; rho = r(1:n);
    bound_rho = 2/sN*sqrt(1+2*cumsum(rho.^2));
    bound_phi = 2/sN*ones(size(phi));
    figure,
    subplot(211), plot(0:n-1, rho, '--o', 0:n-1, [bound_rho,-bound_rho], '-.*'); grid on
    title('auto-correlation'); ylabel('\it\rho _x (k)')
    subplot(212), plot(0:n-1, phi, '--o', 0:n-1, [bound_phi,-bound_phi], '-.*'); grid on
    title('partial-correlation'); ylabel('\it\phi _{kk}')
    
function phi = pacf(rho)
    N = length(rho); phi = zeros(N,1);
    phi(1) = rho(1); phi_kj = rho(1);
    for k=1:N-1
        phi_kj(k+1,1) = (rho(k+1)-rho(k:-1:1)'*phi_kj) / (1-rho(1:k)'*phi_kj);
        phi_kj(1:k) = phi_kj(1:k) - phi_kj(end)*phi_kj(end-1:-1:1);
        phi(k+1,1) = phi_kj(end);
    end
    