function [epsilon, dphim, afamax] = conedrift(nn, ts, afa, f)
% Calculate the residual drift rate of coning compensation.
%
% Prototype: [epsilon, dphim, afamax] = conedrift(nn, ts, afa, f)
% Inputs: nn - subsample number
%         ts - sampling interval
%         afa - half-apex angle (in radians)
%         f - coning frequency (in Hz)
% Outputs: epsilon - drift rate in rad/s
%          dphim - noncommutativity error in rad/s
%
% See also  sculldrift, conecoef, conesimu, cnscl, conepolyn, insupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 30/10/2011, 31/03/2014
global glv
    II = 1;
    for k=1:nn+1
        II = II*(2*k-1);
    end
    omega = 2*pi*f;
    epsilon = afa^2*(omega*ts)^(2*nn+1) * nn*factorial(nn)/(2^(nn+1)*II);
    epsilon = epsilon/(nn*ts);  % the unit is rad/s
    % direct simulation method, regardless of half-apex algle
    nts = nn*ts;
    wm = conesimu(afa, f, ts, nts);  % about x-axis
    if nn>1
        cm = glv.cs(nn-1,1:nn-1)*wm(1:nn-1,:);
    else
        cm = [0, 0, 0];
    end
    dphimc = cross(cm,wm(nn,:));  % calculated noncommutativity error
    dphim = 2*sin(afa/2)^2*(omega*nts-sin(omega*nts)); % theoretical error
    epsilon(2,1) = (dphim-abs(dphimc(1)))/nts;
    dphim = dphim/nts;

    afamax = 3*(omega*ts)^(nn-1)*sqrt(factorial(nn-1)/(2^(nn-3)*II*nn))/glv.deg;