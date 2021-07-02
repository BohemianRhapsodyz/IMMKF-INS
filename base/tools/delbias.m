function out = delbias(in, b)
% Delete bias.
%
% Prototype:  out = delbias(in)
% Inputs: in - input date with bias
%         b - bias
% Output: out - output date with no bias
%
% See also  sumn, meann.

% Copyright(c) 2009-2016, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 23/07/2016, 03/07/2018 
    out = in;
    for k=1:size(in,2)
        if exist('b','var')
            out(:,k) = in(:,k)-b(k);
        else
            out(:,k) = in(:,k)-mean(in(:,k));
        end
    end