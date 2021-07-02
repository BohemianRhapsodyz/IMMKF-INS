function v = iaskew(m) 
% Convert 3x3 askew matrix to 3x1 vector, i.e. the inverse precedure 
% of function 'askew'.
%
% Prototype: v = iaskew(m)
% Input: m - 3x3 askew matrix
% Output: v - corresponding 3x1 vector, such that
%                 |  0   -v(3)  v(2) |
%             m = | v(3)  0    -v(1) |
%                 |-v(2)  v(1)  0    |
%
% See also  askew.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 18/03/2014
	v = [ m(3,2)-m(2,3); 
          m(1,3)-m(3,1); 
          m(2,1)-m(1,2) ]/2.0;
      