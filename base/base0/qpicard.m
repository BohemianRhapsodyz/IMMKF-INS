function [qt0, iter] = qpicard(Wt, T, tol)
% Solution for quaternion differential equation (Picard serial).
% 
% Prototype: [qt0, iter] = qpicard(Wt, T, tol)
% Inputs: Wt - 3xn angluar rate coefficients of the polynomial in 
%              descending powers
%         T - one step forward for time 0 to T
%         tol - error tolerance
% Outputs: qt0 - output quaternion at time ts
%          iter - iteration count
% 
% See also  qrk4, qtaylor, dcmtaylor, wm2wtcoef.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 04/02/2017
    if nargin<3,  tol = 1e-20;  end
    U = [1;0;0;0]; qt0 = U;
    sW2 = size(Wt,2);
    Wt = Wt*diag(T.^(sW2-1:-1:0));  % normalize coefficients
    for iter=1:100
        U = [ -conv(U(2,:),Wt(1,:)) - conv(U(3,:),Wt(2,:)) - conv(U(4,:),Wt(3,:));
               conv(U(1,:),Wt(1,:)) + conv(U(3,:),Wt(3,:)) - conv(U(4,:),Wt(2,:));
               conv(U(1,:),Wt(2,:)) + conv(U(4,:),Wt(1,:)) - conv(U(2,:),Wt(3,:));
               conv(U(1,:),Wt(3,:)) + conv(U(2,:),Wt(2,:)) - conv(U(3,:),Wt(1,:)) ];
        Icoef = T*0.5./(iter*sW2:-1:iter);  % integral coefficients
        U = U.*repmat(Icoef,4,1);
        dqt0 = sum(U,2);   qt0 = qt0 + dqt0;
        if dqt0'*dqt0<tol^2,  break;  end   % error control
    end
    qt0 = qt0/sqrt(qt0'*qt0);

%     q = [1;0;0;0]; qn = q;
%     for k=1:100
%         q = [ -conv(q(2,:),Wt(1,:)) - conv(q(3,:),Wt(2,:)) - conv(q(4,:),Wt(3,:));
%                conv(q(1,:),Wt(1,:)) + conv(q(3,:),Wt(3,:)) - conv(q(4,:),Wt(2,:));
%                conv(q(1,:),Wt(2,:)) + conv(q(4,:),Wt(1,:)) - conv(q(2,:),Wt(3,:));
%                conv(q(1,:),Wt(3,:)) + conv(q(2,:),Wt(2,:)) - conv(q(3,:),Wt(1,:)) ];
%         n1 = 2*(size(q,2):-1:1);   n1 = repmat(n1,4,1);
%         q = [q./n1, [0;0;0;0]];
%         m = size(qn,2); 
%         qn = [q(:,1:end-m), q(:,end-m+1:end)+qn];
%         err = (q(1,:)*q(1,:)'+q(2,:)*q(2,:)'+q(3,:)*q(3,:)'+q(4,:)*q(4,:)')*ts^k;
%         if err<tol, break;  end   % error control
%     end
%     qt0 = [polyval(qn(1,:), ts); polyval(qn(2,:), ts); polyval(qn(3,:), ts); polyval(qn(4,:), ts)];
%     qt0 = qt0/sqrt(qt0'*qt0);
 