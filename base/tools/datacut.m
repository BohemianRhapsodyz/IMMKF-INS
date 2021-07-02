function [data, idx] = datacut(data0, t1, t2)
% Extract data between time tags t1 & t2.
%
% Prototype: [data, idx] = datacut(data0, t1, t2)
% Inputs: data0 - input data, whose last column should be time index
%         t1, t2 - start & end time tags
% Outputs: data, idxi - output data & index in data0

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 17/09/2014
    if nargin<3, t2=data0(end,end); end
    i1 = find(data0(:,end)>=t1, 1, 'first');
    i2 = find(data0(:,end)<=t2, 1, 'last');
    idx = (i1:i2)';
    data = data0(idx,:);
