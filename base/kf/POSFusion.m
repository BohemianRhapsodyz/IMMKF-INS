function psf = POSFusion(rf, xpf, rr, xpr, ratio)
% POS data fusion for forward and backward results.
%
% Prototype: psf = POSFusion(rf, xpf, rr, xpr, ratio)
% Inputs: rf - forward avp
%         xpf - forward state estimation and covariance
%         rr - backward avp
%         xpr - forward state estimation and covariance
%         ratio - the ratio of state estimation used to modify avp.
% Output: the fields in psf are
%         rf, pf - avp & coveriance after fusion
%         r1, p1 - forward avp & coveriance
%         r2, p2 - backward avp & coveriance
%
% See also  insupdate, kfupdate, POSProcessing, posplot.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 22/01/2014
    if nargin<5
        ratio = 1;
    end
    [t, i1, i2] = intersect(rf(:,end), rr(:,end));
    n = size(xpf,2)-1;  n2 = n/2;
    r1 = rf(i1,1:end-1); x1 = xpf(i1,1:n2); p1 = xpf(i1,n2+1:end-1);
    r2 = rr(i2,1:end-1); x2 = xpr(i2,1:n2); p2 = xpr(i2,n2+1:end-1);
    x1(:,1:9) = x1(:,1:9)*ratio; x2(:,1:9) = x2(:,1:9)*ratio;  % ratio
    %  common fusion
    r10 = [r1(:,1:9)-x1(:,1:9),r1(:,10:end)+x1(:,10:end)];
    r20 = [r2(:,1:9)-x2(:,1:9),r2(:,10:end)+x2(:,10:end)];
%     r = ( r10.*p2 + r20.*p1 )./(p1+p2);  
%     p = p1.*p2./(p1+p2);
    [r, p] = fusion(r10, p1, r20, p2);
    % attitude fusion
    for k=1:length(t)
    	r10(k,1:3) = q2att(qdelphi(a2qua(r1(k,1:3)'),x1(k,1:3)'))';
    	r20(k,1:3) = q2att(qdelphi(a2qua(r2(k,1:3)'),x2(k,1:3)'))';
    end
    r(:,1:3) = attfusion(r10(:,1:3), r20(:,1:3), p1(:,1:3), p2(:,1:3));
    rf = [r,t]; r1 = [r10,t]; r2 = [r20,t];
    pf = [p,t]; p1 = [p1,t];  p2 = [p2,t];
    psf = varpack(rf, pf, r1, p1, r2, p2);

    
function att = attfusion(att1, att2, p1, p2)
    att = att1;
	for k=1:size(att1, 1)
    	pf = p1(k,:)./(p1(k,:)+p2(k,:));
    	q1k = a2qua(att1(k,:)');
    	phi = qq2phi(a2qua(att2(k,:)'), q1k);
        att(k,:) = q2att( qaddphi(q1k,phi.*pf') );
	end
    