function res = normv(vects, dim)
% To get vectors' norm along row or column.
%
% Prototype: res = sumn(scr, n, dim)
% Inputs: vects - data source input
%         dim - =1 norm along rows, =2 norm along columns
% Output: res - norm result
%
% See also  N/A.

% Copyright(c) 2009-2016, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 13/08/2016
    if nargin<2,   dim = 2;   end
    res = 0;
    if dim==1
        for k=1:size(vects,1)
            res = res + vects(k,:).^2;
        end
    else
        for k=1:size(vects,2)
            res = res + vects(:,k).^2;
        end
    end
    res = sqrt(res);
