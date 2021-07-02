function [Ft,Hk] = nzFtHk(n)
% Generate nonzero elements in Ft (SINS Error Transition Matrix).
%
% Prototype: [Ft,Hk] = nzFtHk(n)
% Input: n - dimension for Ft, default for 15x15
% Output: Ft - nxn error transition matrix
%
% See also  etm, kffk, kfhk, insinit, insupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 21/02/2015
    ins = insinit(a2qua([.1;.2;21]*pi/180), [1;2;1], posset(34,110,380), 0.01);
    ins.tauG=[10;20;30]; ins.tauA=[100;200;300];
    ins = insupdate(ins, [[111,222,333]*pi/180, [3,4,9.8]]*0.01);
    ins = inslever(ins, [1;2;3]);
    %%
	Ft = etm(ins);
    if nargin==1
        if n>15, Ft(n,n)=0; end
    end
    if n>=34
        Ft(1:3,20:28) = [-ins.wib(1)*ins.Cnb, -ins.wib(2)*ins.Cnb, -ins.wib(3)*ins.Cnb];
        Ft(4:6,29:34) = [ins.fb(1)*ins.Cnb, ins.fb(2)*ins.Cnb(:,2:3), ins.fb(3)*ins.Cnb(:,3)];
    end
    %%
    Hk = zeros(6,n); Hk(:,4:9) = eye(6);
    if n==37
        Hk(1:3,[16:19,35:37]) = [-ins.CW, -ins.an, -eye(3)];
        Hk(4:6,16:19) = [-ins.MpvCnb, -ins.Mpvvn];
    elseif n==21
        Hk(1:3,[16:21]) = [-ins.CW, -eye(3)];
        Hk(4:6,16:18) = [-ins.MpvCnb];
%        Hk(1:3,[19:21]) = [-eye(3)];
    elseif n==19
        Hk(1:3,16:19) = [-ins.CW, [0;0;0]];
        Hk(4:6,16:19) = [-ins.MpvCnb, [0;0;0]];
        Hk(7,[1,19]) = [1,-1];
    elseif n>15
        Hk(1:3,16:19) = [-ins.CW, -ins.an];
        Hk(4:6,16:19) = [-ins.MpvCnb, -ins.Mpvvn];
    end

