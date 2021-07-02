function [sigma, tau, Err] = avar(y0, tau0, str)
% Calculate Allan variance.
%
% Prototype: [sigma, tau, Err] = avar(y0, tau0)
% Inputs: y - data (gyro in deg/hur; acc in g)
%         tau0 - sampling interval
% Outputs: sigma - Allan variance
%          tau - Allan variance correlated time
%          Err - Allan variance error boundary
% Example: 
%     y = randn(100000,1) + 0.00001*[1:100000]';
%     [sigma, tau, Err] = avar(y, 0.1);
%
% See also  meann, sumn.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 22/08/2012
    N = length(y0);
    y = y0; NL = N;
    for k = 1:log2(N)
        sigma(k,1) = sqrt(1/(2*(NL-1))*sum((y(2:NL)-y(1:NL-1)).^2)); % diff&std
        tau(k,1) = 2^(k-1)*tau0;      % correlated time
        Err(k,1) = 1/sqrt(2*(NL-1));  % error boundary
        NL = floor(NL/2);
        if NL<3
            break;
        end
        y = 1/2*(y(1:2:2*NL) + y(2:2:2*NL));  % mean & half data length
    end
    figure;
    if nargin<3, str = '\itx \rm/ \circ/h'; end
    subplot(211), plot(tau0*(1:N)', y0); grid
    xlabel('\itt \rm/ s'); ylabel(str);
    subplot(212), 
    loglog(tau, sigma, '-+', tau, [sigma.*(1+Err),sigma.*(1-Err)], 'r--'); grid
    idx = strfind(str,'/');
    if ~isempty(idx)
        str = str(idx(1):end);
    else
        str = [];
    end
    xlabel('\itt \rm/ s'); ylabel(strcat('\it\sigma_A\rm( \tau ) \rm',str));
