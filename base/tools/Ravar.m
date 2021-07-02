function R = Ravar(R0, diff_w, afa, Rmax, Rmin)
% 计算时间序列的方差，参考《惯性仪器测试与数据分析》9.4.3节
%
% See also mmstat, avar.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 09/03/2017
    len = length(diff_w);
    if len>1
        if ~exist('Rmax','var'), Rmax = inf; end
        if ~exist('Rmin','var'), Rmin = 0; end    
        R0 = diff_w(1)^2;  R = ones(len,1)*R0;
        for k=2:len
            R(k) = Ravar(R(k-1), diff_w(k), afa, Rmax, Rmin);
        end
        figure, plot(R); grid on
    else
        w2 = diff_w^2;
        if w2>R0
            R = w2;
        else
            R = afa*R0 + (1-afa)*w2;
        end
        if exist('Rmax','var'), R = min(R, Rmax); end
        if exist('Rmin','var'), R = max(R, Rmin); end
    end