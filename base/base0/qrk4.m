function q1 = qrk4(q0, wm, T)
% Solution for quaternion differential equation (4-order Runge-Kutta method).
% 
% Prototype: q1 = qrk4(q0, wm, T)
% Inputs: q0 - input quaternion at time 0 
%         wm - angular increment
%         T - one step forward from time 0 to T
% Output: q1 - output quaternion at time T
% 
% See also  btzrk4, qpicard, qtaylor, wm2wtcoef.

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
    k1 = 0.5*qmul(q0,         [1;w0] );
    k2 = 0.5*qmul(q0+T/2*k1,  [1;w01]);
    k3 = 0.5*qmul(q0+T/2*k2,  [1;w01]);
    k4 = 0.5*qmul(q0+T*k3,    [1;w1] );
    q1 = q0 + T/6*(k1+2*(k2+k3)+k4);
    q1 = q1 / sqrt(q1'*q1);
