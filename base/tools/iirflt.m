function flt = iirflt(flt, x)
% Butterworth lowpass IIR filter.
%
% Prototype: flt = iirflt(flt, x)
% Inputs: flt - input filter array
%         x - input data
% Output: flt - output filter array, flt.y(:,1) is the filter result
% 
% See also  N/A.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 29/07/2017
    if nargin<2,   % flt = iirflt([N,Wn])
        N = flt(1); Wn = flt(2);  flt = [];
        [flt.b, flt.a] = butter(N, Wn);
        flt.b = flt.b(:); flt.a = flt.a(:)/flt.a(1);  % normalizes a(1)
        flt.x = zeros(1,length(flt.b));
        flt.y = flt.x;
    else
        if length(x)>1 && size(flt.x,1)==1
            flt.x = repmat(flt.x, length(x), 1);
            flt.y = flt.x;
        end
        flt.x = [x, flt.x(:,1:end-1)];
        flt.y = [flt.x*flt.b-flt.y(:,1:end-1)*flt.a(2:end),flt.y(:,1:end-1)];
    end
