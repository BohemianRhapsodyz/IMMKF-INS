function [rts, state] = roots3(coefs)
% Find the roots of cubic equation: c(1)*x^3 + c(2)*x^2 + c(3)*x + c(4) = 0.
% Make sure c(1)~=0 ! This routine is convenient for C-language programmer.
%
% Prototype: [rts, state] = roots3(coefs)
% Input: coefs - = [c(1), c(2), c(3), c(4)]
% Outputs: rts - roots [x1, x2, x3]
%          state - root state
%                  = 1, 3 real roots with x1=x2=x3;
%                  = 2, 3 real roots with x2=x3
%                  = 3, 3 different real roots
%                  = 4, 1 real root and 2 conjugate complex roots
%
% See also  N/A.

% Copyright(c) 2009-2016, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 01/02/2016
	coefs = coefs/coefs(1); a = coefs(2); b = coefs(3); c = coefs(4);
	p = (3*b-a^2)/3; q = (2*a^3-9*a*b+27*c)/27;
%     delta = q^2/4+p^3/27;
    delta = (4*a^3*c-a^2*b^2-18*a*b*c+4*b^3+27*c^2)/108;
    if delta>10*eps  % 1 real root and 2 conjugate complex roots
        k1 = rt31(-q/2+sqrt(delta));  k2 = rt31(-q/2-sqrt(delta));
        x1 = k1+k2;
        x2 = -1/2*x1+1i*sqrt(3)/2*(k1-k2);
        x3 = x2';
        state = 4;
    elseif delta<-10*eps  % 3 different real roots
        T = -q*sqrt(-27*p)/2/p^2;
        theta = acos(T);
        x0 = 2*sqrt(-p/3); x1 = x0*cos(theta/3); x2 = x0*cos(theta/3-pi*2/3); x3 = x0*cos(theta/3+pi*2/3);
        state = 3;
    else  % 3 real roots with x2=x3 
        x1 = rt31(-4*q);
        x2 = -x1/2; x3 = x2;
        state = 2;
        if p>-10*eps, state = 1; end  % 3 real roots with x1=x2=x3;
    end
    rts = [x1; x2; x3]-a/3;

function r = rt31(f)
   if f>=0
       r = f^(1/3);
   else
       r = -(-f)^(1/3);
   end