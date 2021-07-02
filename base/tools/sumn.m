function res = sumn(scr, n, dim)
% Sum successive n elements to form as one element.
%
% Prototype: res = sumn(scr, n, dim)
% Inputs: scr - data source input to be summed
%         n - element number to be summed
%         dim - =1 summed along rows, =2 summed along columns
%
% See also  meann, cumint.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 16/04/2009, 09/03/2014
    if nargin<3
        dim = 1;
    end
    res = cumsum(scr, dim);
    if dim==1
        res = res(n:n:end, :);
        res = [res(1,:); diff(res,1,1)];
    else
        res = res(:,n:n:end);
        res = [res(:,1), diff(res,1,2)];
    end
