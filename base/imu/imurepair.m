function imu = imurepair(imu0, method)
% If imu0 loss some frames, then repair them.
%
% Prototype: imu = imurepair(imu0, method)
% Inputs: 
%    imu0 - raw SIMU data
%    method - interpolation method
% Output: imu - repaired new SIMU date
%
% See also  imuresample.

% Copyright(c) 2009-2015, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi'an, P.R.China
% 17/04/2015
    if nargin<2, method = 'nearest'; end
    ts = diff(imu0(1:2,end)); % make sure the fist two frames are not lost
    ts15 = ts*1.5;
    t = imu0(:,end);
    len = length(t);
    for k=2:len
        if t(k)-t(k-1)>ts15, t = [t(1:k-1); t(k-1)+ts; t(k:end)]; end
    end
    imu = interp1(imu0(:,end), imu0(:,1:6), t, method);   % 'linear' or 'spline' interpolation
    imu = [imu, t];
 