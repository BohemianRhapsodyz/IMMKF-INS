function imu = imuresample(imu0, ts, t1, method)
% Re-sample SIMU data in a new sampling interval.
%
% Prototype: imu = imuresample(imu0, ts, t1, method)
% Inputs: 
%    imu0 - raw SIMU data (imu0(:,7) is old sampling time sequence)
%    ts - new sampling interval (in time second)
%    t1 - sampling time for first SIMU record
%    method - resampling interpolation method
% Output: imu - new SIMU date with sampling interval ts
%
% See also  trjsimu, imufile, imuplot, insupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi'an, P.R.China
% 10/08/2011, 09/10/2013, 12/03/2014, 14/09/2014
    n = size(imu0,2);
    t0 = imu0(:,n);  ts0 = t0(2)-t0(1);
    t0 = [t0(1)-ts0; t0];
    imu0 = cumsum([zeros(1,n-1); imu0(:,1:n-1)]);  % cumulated increment
    if nargin<4, method='linear'; end
    if nargin==3, 
        if ischar(t1), method=t1; t1=fix(t0(1)); end 
    end
    t1 = ceil(t0(1)/ts)*ts;
%     if nargin<3,  t1=fix(t0(1));  end
%     if t1<t0(1), t1=t1+fix((t0(1)-t1)/ts)*ts;  end
%     if t1-ts>=t0(1),  t1=t1-ts;  end
    t = (t1:ts:t0(end))';
    imu = interp1(t0, imu0, t, method);   % 'linear' or 'spline' interpolation
    imu = [diff(imu), t(2:end)];  % restore increment (de-cumulate)
 