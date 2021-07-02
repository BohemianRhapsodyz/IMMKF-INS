function yi = quantiz(x, q)
% Increment quantization.
%
% Prototype: yi = quantiz(x, q)
% Inputs: x - data source to be quantized
%         q - quantitative equivalent
% Output: yi - quantized data output
%
% See also  imuresample.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 07/11/2013
    x = fix(cumsum(x,1)/q);
    yi = diff([zeros(1,size(x,2)); x])*q;
