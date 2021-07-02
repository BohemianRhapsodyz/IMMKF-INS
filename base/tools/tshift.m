function varargout = tshift(varargin)
% Time tag shift.
%
% Prototype: varargout = tshift(varargin)
% Examples: 1) [o1, o2, o3] = tshift(i1, i2, i3, t0)
%           2) [o1, o2, o3] = tshift(i1, i2, i3)   % t0=0
%
% See also  xxx.

% Copyright(c) 2009-2015, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 06/04/2015
    t0 = varargin{1}(1,end); t00 = 0;
    kk = nargin;
    if length(varargin{kk})==1, kk=kk-1; t00=varargin{k}(1); end
    for k=2:kk
        t0 = min(t0, varargin{k}(1,end));
    end
    varargout = varargin(1:kk);
    for k=1:kk
        varargout{k}(:,end) = varargin{k}(:,end)-(t0-t00);
    end

