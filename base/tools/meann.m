function res = meann(scr, n, dim)
% Sum successive n elements to form as one element, then average.
%
% Prototype: res = meann(scr, n, dim)
% Inputs: scr - data source input to be averaged
%         n - element number to be averaged
%         dim - =1 averaged along rows, =2 averaged along columns
%
% See also  sumn, avar.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 16/04/2009, 09/03/2014
    if nargin<3
        dim = 1;
    end
    res = sumn(scr, n, dim)/n;
