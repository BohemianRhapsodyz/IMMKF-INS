function [data, rate, beta, q] = markov2(sigma, tau, ts, len, ifplot)
% The generator of 1st markov process.
%
% Prototype: [data, rate, beta, q] = markov2(sigma, tau, ts, len, ifplot)
% Inputs: sigma - standard deviation of the process
%         tau - correlation time
%         ts - sampling interval
%         len - the length of data generation 
% Outputs: data - data generation
%          rate - change slope of data
%          beta -  the inverse of correlation time
%          q - white noise intensity of the process generator
%
% See also  markov1.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 22/04/2012
    if nargin<5,  ifplot = 0;  end
    m = length(sigma);
    beta = 2.146./tau;
    q = 4*beta.^3.*sigma.^2; sQk = sqrt(q*ts^3);
    a1 = 2*(1-beta*ts); a2 = -(1-beta*ts).^2;
    Ntao = ceil(max(tau)/ts); len1 = Ntao + len;
    data = zeros(len1, m);
    for k=1:m
        data(:,k) = filter(sQk(k), [1 -a1(k) -a2(k)], randn(len1,1));
    end
    rate = diff(data)/ts;
    data = data(end-len+1:end,:); % remove the first Ntao transit elements
    rate = rate(end-len+1:end,:);
    if ifplot==1
        myfigure;
        bx = [1;len]*ts; by = [1;1]*sigma(1);
        plot((1:len)'*ts,[data,rate], bx,[by,-by],'m--');
        xygo('2^{nd}  order  Markov  process  &  slope');
    end
