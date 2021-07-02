function c = polycross(a, b)
% The cross product of polynomial coefficient vectors a and b, i.e. c = a x b,
% using convolution alogrithm.
%
% Prototype: c = polycross(a, b)
% Inputs: a, b - polynomial coefficient [3Xn] vectors
% Output: c - c = a x b, [3X(2n-1)] vectors
%
% See also  polydot, polydotmul, polyadd, polyintn, polycut.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 15/02/2017
    c = [ conv(a(2,:),b(3,:))-conv(a(3,:),b(2,:));
    	  conv(a(3,:),b(1,:))-conv(a(1,:),b(3,:));
          conv(a(1,:),b(2,:))-conv(a(2,:),b(1,:)) ];