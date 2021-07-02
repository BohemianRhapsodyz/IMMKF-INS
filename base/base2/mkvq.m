function q = mkvq(R0, tau, nq)
% Calculate the white noise intensity of 1st order Markov process.
%
% Prototype: q = mkvq(R0, tau)
% Inputs: R0 - standard deviation of the process
%         tau - correlation time
%         nq - output dimension
% Output: q - white noise intensity of 1st Markov process
%
% See also  markov1, ar1coefs.

% Copyright(c) 2009-2015, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 14/02/2015
    lR = length(R0); lt = length(tau);
    if lR==1&&lt>1, R0 = repmat(R0, size(tau)); end
    if lt==1&&lR>1, tau = repmat(tau, size(R0)); end
    q = 2*R0./tau;
    if nargin==3&&lR==1&&lt==1, q = repmat(q, [nq,1]); end
