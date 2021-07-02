function rv = btzrk4(wm, T)
% Solution for Bortz differential equation (4-order Runge-Kutta method).
% 
% Prototype: rv = btzrk4(wm, T)
% Inputs: wm - angular increment
%         T - one step forward for time 0 to T
% Output: rv - rotation vector at time T
% 
% See also  qrk4, qpicard, qtaylor, wm2wtcoef.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 13/02/2017
    nn = size(wm,1);
    if nn~=2
        coef = wm2wtcoef(T/nn, nn);
        Wt = wm'*coef;
        t = [0,T/2,T];
        wt = [polyval(Wt(1,:),t); polyval(Wt(2,:),t); polyval(Wt(3,:),t)];
        w0 = wt(:,1); w01 = wt(:,2); w1 = wt(:,3);
    else
        a = (3*wm(1,:)-wm(2,:))'/T;
        b = 2*(-wm(1,:)+wm(2,:))'/T^2;
        w0 = a; w01 = a+b*T; w1 = a+2*b*T;
    end
    k1 = w0;
    k2 = w01 + T/4*cros(k1,w01) + T^2/48*cros(k1,cros(k1,w01));
    k3 = w01 + T/4*cros(k2,w01) + T^2/48*cros(k2,cros(k2,w01));
    k4 = w1  + T/2*cros(k3,w1 ) + T^2/12*cros(k3,cros(k3,w1 ));
    rv = T/6*(k1+2*(k2+k3)+k4);
