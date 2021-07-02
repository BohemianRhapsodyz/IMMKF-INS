function varargout = prealloc(row, varargin)
% Pre-allocate memory for variables before being used in loop. 
% all of the variables share the same row, but may have different 
% columns listed in varargin.
%
% Prototype: varargout = prealloc(row, varargin)
%
% See also  setvals.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 13/02/2014
    for k=1:nargout
        if nargin==2  % if all of the outputs share the same column
            varargout{k} = zeros(row, varargin{1});
        else
            varargout{k} = zeros(row, varargin{k});
        end
    end