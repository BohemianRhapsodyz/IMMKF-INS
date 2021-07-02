function [nn, ts, nts] = nnts(nn, ts)
% Set subsample number, sampling interval and their product.
%
% Prototype: [nn, ts, nts] = nnts(nn, ts)
% Inputs: nn - subsample number
%         ts - sampling interval
% Outputs: ss, ts - the same as above
%         nts - nts = nn*ts
%
% Example:
%        [nn, ts, nts] = nnts(2, 0.01);
%
% See also  setvals.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 27/03/2014

%     nn = nn; ts = ts;
    nts = nn*ts;