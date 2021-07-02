function res = accstatic(vm, n)
% VG attitude test.
%
% Prototype: res = vgtest(imu, att, T)
% Inputs: vm - acc velocity increment
%         n - FIR filter length
% Output: res - acc norm filtering out
% 
% See also  N/a.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 01/08/2017
    ts = diff(vm(1:2,end));
    acc = vm(:,1:3)/ts;
    b = ones(n,1)/n;
    x = normv(acc(:,1:3));
    y = filter(b,1,[acc(:,1:3),x]);
    m = y;
    for k=n+1:length(y)
        m(k,:) = max(y(k-n:k,:))-min(y(k-n:k,:));
    end
    res = [x,y,m];
    figure
    subplot(211), plot(vm(2*n:end,end), [acc(2*n:end,:),x(2*n:end,:)]); xygo('f / m/ss')
    subplot(212), plot(vm(2*n:end,end), m(2*n:end,:)); xygo('norm(f) / m/ss')