function pos2dplot(pos0, varargin)
% Multi-pos 2D trajectory plot.
%
% Prototype: pos2dplot(pos0, varargin)
% Inputs: pos0 - [lat, lon, hgt, t]
%         varargin - other pos parameter
%          
% See also  inserrplot, kfplot, gpsplot, imuplot, pos2dxyz.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 24/05/2015
    lat0 = pos0(1,1); lon0 = pos0(1,2);
    eth = earth(pos0(1,1:3)');
    myfigure
    plot(0, 0, 'rp'); hold on;
    plot((pos0(:,2)-lon0)*eth.RMh, (pos0(:,1)-lat0)*eth.clRNh)
    if nargin>1
        clr = 'rgmycb';
        for k=1:length(varargin)
            pos0 = varargin{k};
            plot((pos0(:,2)-lon0)*eth.RMh, (pos0(:,1)-lat0)*eth.clRNh, clr(k));
        end
    end
    xygo('est', 'nth');
	legend(sprintf('%.6f, %.6f / DMS', r2dms(lat0)/10000,r2dms(lon0)/10000));

