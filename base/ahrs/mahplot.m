function mahplot(ae, attref)
% Mahony-AHRS output plot.
%
% Prototype: mahplot(ae)
% Inputs: ae - attitude & drift
%         attref - attitude reference
%          
% See also  insplot, inserrplot, kfplot, gpsplot, magplot.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 30/06/2017
global glv
    if nargin<2, attref=ae(:,1:3)*0; end
    myfigure;
    subplot(221), plot(ae(:,end), ae(:,1)/glv.deg, attref(:,end), attref(:,1)/glv.deg), xygo('p')
    subplot(222), plot(ae(:,end), ae(:,2)/glv.deg, attref(:,end), attref(:,2)/glv.deg), xygo('r')
    subplot(223), plot(ae(:,end), ae(:,3)/glv.deg, attref(:,end), attref(:,3)/glv.deg), xygo('y')
    subplot(224), plot(ae(:,end), ae(:,4:6)/glv.dph), xygo('eb')
