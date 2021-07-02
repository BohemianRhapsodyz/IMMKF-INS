function [coef, rho, epsilon] = conecoef(nn, ts, afa, f)
% The generation of coning error compensation coefficients.
%
% Prototype: [coef, rho, epsilon] = conecoef(nn, ts, afa, f)
% Inputs: nn - sub-sample number
%         ts - sampling interval
%         afa - half-apex angle
%         f - coning frequency (in Hz)
% Outputs: coef - coning compensation coefficients
%          rho - drift ratio (no unit, independent of ts,afa,omega)
%          epsilon - drift rate in rad/s
%
% See also  conepolycoef, conedrift, cnscl, conesimu, insupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 28/10/2013
    j1 = 1:2:2*nn+1;          % j1 = [1 3 5 7 ... 2nn+1]
    cj = cumprod(1:2*nn+1);   % factorial up to 2nn+1
    cj = -1./(2*cj(1:2:end)); % cj = -1/(2*[1! 3! 5! ... (2nn+1)!])
    A = zeros(nn,nn-1);
    for i=1:nn-1
        hs = 2*(nn-i);
        a = [hs, hs, 2-hs, -2-hs]/nn/2;
        for j=1:nn
            A(j,i) = sum(a.^j1(j+1).*cj(j+1))*(-2);
        end
    end
    coef = A(1:nn-1,:)^-1*cj(2:nn)';
    if nargin==1, return; end;
    rho = (-1)^nn*(cj(nn+1)'-A(nn,:)*coef);
    if nargin>1
        omega = 2*pi*f; nts = nn*ts;
        epsilon = rho*afa^2*omega*(omega*nts)^(2*nn);
        % epsilon = conedrift(nn, ts, afa, f); % should be the same as above in small half-apex angle
    end

