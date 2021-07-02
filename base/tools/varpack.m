function stru = varpack(varargin)
% Pack all of the input variables into a structure array, and the
% structure field names are the same as the input variable names.
%
% Prototype: stru = varpack(varargin)
%
% See also  setvals.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 10/03/2014
    stru = [];
    for k=1:nargin
        stru = setfield(stru, inputname(k), varargin{k});
%         if ~isempty(inputname(k))
%             stru = setfield(stru, inputname(k), varargin{k});
%         end
    end