function kf = RLS(kf, zk)
% Recursive Least Square filter.
%
% Prototype: kf = RLS(kf, zk)
% Inputs: kf - filter structure array
%         zk - measurement vector
% Output: kf - filter structure array after filtering
%
% See also  kfupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 16/09/2013
    if ~isfield(kf, 'Rk') 
        kf.Rk = eye(size(kf.Hk,1));
    end
    kf.Pxzk = kf.Pxk*kf.Hk';  
    kf.Pzk = kf.Hk*kf.Pxzk + kf.Rk;  
    kf.Kk = kf.Pxzk*kf.Pzk^-1;
    kf.xk = kf.xk + kf.Kk*(zk-kf.Hk*kf.xk);
    kf.Pxk = kf.Pxk - kf.Kk*kf.Pxzk';
    kf.Pxk = (kf.Pxk+kf.Pxk')*0.5;
