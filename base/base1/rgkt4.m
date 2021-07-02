function y1 = rgkt4(hfun, x01, y0, h)
% Solve differential equation 'dy/dx=fun(x,y)' using Runge-Kutta method.
%
% Prototype: y1 = rgkt4(ff, x01, y0, h)
% Inputs: hfun - differential equation handle
%         x01 - x01 = [x0, xhalf, x1], independant variable vectors at 
%               times t0, t1/2 and t1
%         y0 - dependant variable vector at time t0
%         h - time interval from time t0 to time t1, i.e. h = t1-t0
% Output: y1 - dependant variable vector at time t1
%
% See also  N/A.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 05/05/2014
    x0 = x01(:,1);  xhalf = x01(:,2);  x1 = x01(:,3);
    k1 = hfun(x0,    y0);
    k2 = hfun(xhalf, y0+h/2*k1);
    k3 = hfun(xhalf, y0+h/2*k2);
    k4 = hfun(x1,    y0+h*k3);
    y1 = y0 + h/6*(k1+2*(k2+k3)+k4);
