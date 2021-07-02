function [y, Pyy, Pxy, X, Y] = ut(x, Pxx, hfx, tpara, alpha, beta, kappa)
% Unscented transformation.
%
% Prototype: [y, Pyy, Pxy, X, Y] = ut(x, Pxx, hfx, tpara, alpha, beta, kappa)
% Inputs: x, Pxx - state vector and its variance matrix
%         hfx - a handle for nonlinear state equation
%         tpara - some time-variant parameter pass to hfx
%         alpha, beta, kappa - parameters for UT transformation
% Outputs: y, Pyy - state vector and its variance matrix after UT
%          Pxy - covariance matrix between x & y
%          X, Y - Sigma-point vectors before & after UT
%
% See also  ukf

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 27/09/2012
    n = length(x);
    lambda = alpha^2*(n+kappa) - n;
    gamma = sqrt(n+lambda);
    Wm = [lambda/gamma^2; repmat(1/(2*gamma^2),2*n,1)];  
    Wc = [Wm(1)+(1-alpha^2+beta); Wm(2:end)];
    sPxx = gamma*chol(Pxx)';    % Choleskey decomposition
    xn = repmat(x,1,n); 
    X = [x, xn+sPxx, xn-sPxx];
    Y(:,1) = feval(hfx, X(:,1), tpara); m=length(Y); y = Wm(1)*Y(:,1);
    Y = repmat(Y,1,2*n+1);
    for k=2:1:2*n+1     % Sigma points nolinear propagation
        Y(:,k) = feval(hfx, X(:,k), tpara);
        y = y + Wm(k)*Y(:,k);
    end
    Pyy = zeros(n); Pxy = zeros(n,m);
    for k=1:1:2*n+1
        yerr = Y(:,k)-y;
        Pyy = Pyy + Wc(k)*(yerr*yerr');  % variance
        xerr = X(:,k)-x;
        Pxy = Pxy + Wc(k)*xerr*yerr';  % covariance
    end
