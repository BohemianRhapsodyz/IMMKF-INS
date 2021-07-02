function baroplot(baro, href)
% Barometer plot.
%
% Prototype: baroplot(baro)
% Input: baro - barometer outpu in meter
%          
% See also  magplot, gpsplot, imuplot, insplot, inserrplot, kfplot.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 17/03/2017
    myfigure;
    plot(baro(:,end), baro(:,1)), xygo('\itt/ \rms', 'Baro / m');
    if nargin>1
        plot(href(:,end), href(:,1)-href(1,1)+baro(1,1), 'r');
        legend('baro', sprintf('href+: %.2f', -href(1,1)+baro(1,1)'));
    end
