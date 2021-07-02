function [x, p] = fusion(x1, p1, x2, p2)
% Data fusion.
%
% Prototype: [x, p] = fusion(x1, p1, x2, p2)
% Inputs: x1, p1 - state estimation and covariance by methods 1
%         x2, p2 - state estimation and covariance by methods 2
% Outputs: x, p - estimation and variance fusion
% Alogrithm notes:
% If p1 & p2 are covariance matrices, then:
%     x = ( p2*x1 + p1*x2 )/(p1+p2)
%     p = p1*p2/(p1+p2)
% If p1 & p2 are diagnal matrices of covariance, then:
%     x = ( p2.*x1 + p1.*x2 )./(p1+p2)
%     p = p1.*p2./(p1+p2)
%
% See also  kfupdate, POSFusion.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 13/12/2013
    [m,n] = size(p1);
    if m==n && size(x1,2)==1 % p1 is matrix P, but not diag(P) 
        x = ( p2*x1 + p1*x2 )/(p1+p2);  
        p = p1*p2/(p1+p2);
    else
        p = p1+p2;
        x = ( p2.*x1 + p1.*x2 )./p;
        p = p1.*p2./p;
    end
