function [data, beta, q] = markov1(sigma, tau, ts, len, ifplot)
% The generator of 1st Markov process.
%
% Prototype: [data, beta, q] = markov1(sigma, tau, ts, len, ifplot)
% Inputs: sigma - standard deviation of the process
%         tau - correlation time
%         ts - sampling interval
%         len - the length of data generation
% Outputs: data - data generation
%          beta -  the inverse of correlation time
%          q - white noise intensity of the process generator
%
% Example:
%          sigma = 2;  tau = 10;  ts = 0.1;
%          [data, beta, q] = markov1(sigma, tau, ts, fix(100*tau/ts), 1);
%
% See also  mkvq, markov2, ar1coefs, imuadderr.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 22/04/2012
    if nargin<5,  ifplot = 0;  end
    m = length(sigma);
    beta = 1./tau;
    q = 2*sigma.^2.*beta; sQk = sqrt(q*ts);
    a1 = exp(-beta*ts);
    Ntao = ceil(max(tau)/ts); len1 = Ntao + len;
    data = zeros(len1, m);
    for k=1:m
        data(:,k) = filter(sQk(k), [1 -a1(k)], randn(len1,1));
    end
    data = data(end-len+1:end,:); % remove the first Ntao transit elements
    if ifplot==1
        myfigure;
        bx = [1;len]*ts; by = [1;1]*sigma(1);
        plot((1:len)'*ts,data, bx,[by,-by],'m--');
        xygo('1^{st}  order  Markov  process');
    end
