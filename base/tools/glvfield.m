function varargout = glvfield(names)
% Get structure field values from global 'glv', where input 'names' is 
% a string containing field names separated by comma.
%
% Prototype: varargout = glvfield(names)
% Examples:
%    1. [Re, e2] = glvfield('Re, e2');
%    2. [deg, mil, dph] = glvfield('deg, mil, dph');
%
% See also  setvals, prealloc, varpack.

% Copyright(c) 2009-2015, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 09/02/2015
global glv
    names(strfind(names, ' '))=[];  % delete blank space
    names = [',', names, ','];
    comma = strfind(names, ',');
    for k=1:nargout
    	varargout{k} = getfield(glv, names(comma(k)+1:comma(k+1)-1));
    end