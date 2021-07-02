function m = askew(v)
% Convert 3x1 vector to 3x3 askew matrix.
%
% Prototype: m = askew(v)
% Input: m - 3x1 vector
% Output: v - corresponding 3x3 askew matrix, such that
%                 |  0   -v(3)  v(2) |
%             m = | v(3)  0    -v(1) |
%                 |-v(2)  v(1)  0    |
%
% See also  iaskew, cros.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 25/02/2008
    m = [ 0,     -v(3),   v(2); 
          v(3),   0,     -v(1); 
         -v(2),   v(1),   0     ];
      