function [qt0, iter] = qtaylor(Wt, T, tol)
% Solution for quaternion differential equation (quaternion Taylor serial).
% 
% Prototype: [qt0, iter] = qtaylor(Wt, T, tol)
% Inputs: Wt - 3xn angluar rate coefficients of the polynomial in 
%                 descending powers
%         T - one step forward for time 0 to T
%         tol - error tolerance
% Outputs: qt0 - output quaternion at time ts
%          iter - iteration count
% 
% See also  dcmtaylor, qrk4, qpicard, wm2wtcoef.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 04/02/2017
    if nargin<3, tol=1e-20; end
    sz2 = size(Wt,2);
    der = 1;  Wq = zeros(4,sz2);
    for k=sz2:-1:1
        Wq(:,k) = [0;Wt(:,k)*der/2]; der = der*(sz2-k+1);  % polyder
    end
    qt0 = [1;0;0;0];  yh = zeros(1,sz2);  yh(end) = 1; tsn1 = 1;
    qq = zeros(4,sz2+1);  qq(:,end-1) = qt0;
    m = 50;
    for iter=1:m
        k1 = max(sz2-iter+1,1);
        for k=k1:sz2
            qq(:,end) = qq(:,end) + yh(k)*qmul(qq(:,k),Wq(:,k));
        end
        tsn1 = tsn1*T/iter;   % ts^iter/factorial(iter)
        qt0 = qt0 + tsn1*qq(:,end);
        if tsn1*sqrt(qq(:,end)'*qq(:,end))<tol,  break;  end   % error control
        yh = [yh(2:end),0] + yh;  % Yanghui coefficients
        qq = [qq(:,2:end), zeros(4,1)]; % move left
    end
    qt0 = qt0/sqrt(qt0'*qt0);
