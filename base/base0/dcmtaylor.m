function [Ct0, iter] = dcmtaylor(Wt, T, tol)
% Solution for DCM differential equation (DCM Taylor serial).
% 
% Prototype: [Ct0, iter] = dcmtaylor(Wt, T, tol)
% Inputs: Wt - 3xn angluar rate coefficients of the polynomial in 
%                 descending powers
%         T - one step forward for time 0 to T
%         tol - error tolerance
% Outputs: Ct0 - output DCM at time T
%          iter - iteration count
% 
% See also  qtaylor, qpicard, wm2wtcoef.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 04/02/2017
    if nargin<3, tol=1e-20; end
    sz2 = size(Wt,2);
    AWt = zeros(3,3,sz2);
    der = 1;
    for k=sz2:-1:1
        AWt(:,:,k) = askew(Wt(:,k)*der); der = der*(sz2-k+1);  % polyder
    end
    Ct0 = eye(3);  yh = zeros(1,sz2);  yh(end) = 1; tsn1 = 1;
    DCM = zeros(3,3,sz2+1);  DCM(:,:,end-1) = Ct0;
    m = 50;
    for iter=1:m
        k1 = max(sz2-iter+1,1);
        for k=k1:sz2
            DCM(:,:,end) = DCM(:,:,end) + yh(k)*DCM(:,:,k)*AWt(:,:,k);
        end
        tsn1 = tsn1*T/iter;   % ts^iter/factorial(iter)
        Ct0 = Ct0 + tsn1*DCM(:,:,end);
        if iter>sz2 && tsn1*max(max(abs(DCM(:,:,end))))<tol,  break;  end   % error control
        yh = [yh(2:end),0] + yh;  % Yanghui coefficients
        DCM(:,:,1:end-1) = DCM(:,:,2:end); DCM(:,:,end) = zeros(3); % move left
    end
    Ct0 = mnormlz(Ct0);
   
%     if nargin<3, tol=1e-20; end
%     Ct0 = eye(3);  yh = 1;  tsn1 = ts;
%     sz2 = size(Wt,2);  m = 50;
%     DCM = repmat({zeros(3)},1,m); AWt = DCM;
%     DCM{1} = Ct0; AWt{1} = askew(Wt(:,end));
%     for iter=2:m
%         if iter>sz2, Wt = [0;0;0];
%         else         Wt = Wt(:,1:end-1).*repmat(size(Wt,2)-1:-1:1,3,1);  end  % polyder
%         AWt{iter} = askew(Wt(:,end));
%         for k=1:iter-1
%             DCM{iter} = DCM{iter} + yh(k)*DCM{k}*AWt{iter-k};
%         end
%         yh = [yh,0] + [0,yh];  % Yanghui coefficients
%         Ct0 = Ct0 + tsn1*DCM{iter};
%         if iter>sz2 && tsn1*max(max(abs(DCM{iter})))<tol,  break;  end   % error control
%         tsn1 = tsn1*ts/iter;  % ts^k/factorial(k)
%     end
%     Ct0 = mnormlz(Ct0);

