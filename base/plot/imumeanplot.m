function imu = imumeanplot(imu, n)
% SIMU data plot.
%
% Prototype: imu = imumeanplot(imu, n)
% Inputs: imu - SIMU data, the last column is time tag
%         n - mean count
%          
% See also  imuplot, imuresample.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 04/03/2018
    if nargin<2, n=100; end
    imu = [meann(imu(:,1:6),n)*n,imu(n:n:end,end)];
    imuplot(imu,1);