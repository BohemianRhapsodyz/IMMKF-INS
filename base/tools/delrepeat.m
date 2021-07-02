function data = delrepeat(data, clm_idx)
% Delete repeated data.
%
% Prototype: data = delrepeat(data, clm_idx)
% Inputs: 
%    data - data with repeated rows
%    clm_idx - column for index
% Output: data - data with no repeated rows
%
% See also  imurepair, imuresample.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi'an, P.R.China
% 17/06/2017
    if nargin<2, clm_idx=size(data,2); end
    data = data(diff([data(1,clm_idx)-1;data(:,clm_idx)])>0,:);
    