function POSplot(psf)
% Plot the POS results.
%
% Prototype: POSplot(psf)
% Input: the fields in psf are
%         rf, pf - avp error and coveriance after fusion
%         r1, p1 - forward avp error and coveriance
%         r2, p2 - backward avp error and coveriance
%
% See also  POSProcessing, POSFusion, kfplot.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 22/01/2014
    POSplot1(psf.rf, psf.r1, psf.r2, psf.rf(:,end));
    POSplot2(sqrt(psf.pf), sqrt(psf.p1), sqrt(psf.p2), psf.rf(:,end));

function POSplot1(x, x1, x2, t)
global glv
    arcdeg = glv.deg; arcsec = glv.sec; Re = glv.Re; 
    ppm = glv.ppm; ug = glv.ug; dph = glv.dph;
    if nargin<4,  t=1;   end
    if length(t)==1,  t=(1:length(x))'*t;   end
    myfigure;
    subplot(421),  hold on; xygo('pr');
        plot(t, x1(:,1:2)/arcdeg, ':', 'LineWidth',2),
        plot(t, x2(:,1:2)/arcdeg, '-.', 'LineWidth',2), 
        plot(t,  x(:,1:2)/arcdeg, 'm'), 
    subplot(422), hold on; xygo('y');
        plot(t, x1(:,3)/arcdeg, ':', 'LineWidth',2),
        plot(t, x2(:,3)/arcdeg, '-.', 'LineWidth',2), 
        plot(t,  x(:,3)/arcdeg, 'm'), 
    subplot(423), hold on; xygo('V');
        plot(t, x1(:,4:6), ':', 'LineWidth',2), 
        plot(t, x2(:,4:6), '-.', 'LineWidth',2), 
        plot(t,  x(:,4:6), 'm'), 
    subplot(424), hold on; xygo('DP');
        plot(t, [(x1(:,7)-x1(1,7))*Re,(x1(:,8)-x1(1,8))*Re,x1(:,9)-x1(1,9)], ':', 'LineWidth',2),
        plot(t, [(x2(:,7)-x2(1,7))*Re,(x2(:,8)-x2(1,8))*Re,x2(:,9)-x2(1,9)], '-.', 'LineWidth',2), 
        plot(t, [( x(:,7)- x(1,7))*Re,( x(:,8)- x(1,8))*Re, x(:,9)- x(1,9)], 'm'),
    subplot(425), hold on, xygo('eb');
        plot(t, x1(:,10:12)/dph, ':', 'LineWidth',2);
        plot(t, x2(:,10:12)/dph, '-.', 'LineWidth',2), 
        plot(t,  x(:,10:12)/dph, 'm'), 
    subplot(426), hold on, xygo('db');
        plot(t, x1(:,13:15)/ug, ':', 'LineWidth',2);
        plot(t, x2(:,13:15)/ug, '-.', 'LineWidth',2), 
        plot(t,  x(:,13:15)/ug, 'm'), 
    subplot(427), hold on, xygo('L');
        plot(t, x1(:,16:18), ':', 'LineWidth',2);
        plot(t, x2(:,16:18), '-.', 'LineWidth',2), 
        plot(t,  x(:,16:18), 'm'), 
    subplot(428), hold on, xygo('dT');
        plot(t, x1(:,19), ':', 'LineWidth',2);
        plot(t, x2(:,19), '-.', 'LineWidth',2), 
        plot(t,  x(:,19), 'm'), 
if size(x,2)>=34
    myfigure;
    subplot(321), hold on, xygo('dKg');
        plot(t, x1(:,[1,5,9]+19)/ppm, ':', 'LineWidth',2);
        plot(t, x2(:,[1,5,9]+19)/ppm, '-.', 'LineWidth',2), 
        plot(t,  x(:,[1,5,9]+19)/ppm, 'm'), 
    subplot(322), hold on, xygo('dAg');
        plot(t, x1(:,[2,3,6]+19)/arcsec, ':', 'LineWidth',2);
        plot(t, x2(:,[2,3,6]+19)/arcsec, '-.', 'LineWidth',2), 
        plot(t,  x(:,[2,3,6]+19)/arcsec, 'm'), 
    subplot(324), hold on, xygo('dAg');
        plot(t, x1(:,[4,7,8]+19)/arcsec, ':', 'LineWidth',2);
        plot(t, x2(:,[4,7,8]+19)/arcsec, '-.', 'LineWidth',2), 
        plot(t,  x(:,[4,7,8]+19)/arcsec, 'm'), 
    subplot(323), hold on, xygo('dKa');
        plot(t, x1(:,[10,13,15]+19)/ppm, ':', 'LineWidth',2);
        plot(t, x2(:,[10,13,15]+19)/ppm, '-.', 'LineWidth',2), 
        plot(t,  x(:,[10,13,15]+19)/ppm, 'm'), 
    subplot(326), hold on, xygo('dAa');
        plot(t, x1(:,[11,12,14]+19)/arcsec, ':', 'LineWidth',2); 
        plot(t, x2(:,[11,12,14]+19)/arcsec, '-.', 'LineWidth',2),  
        plot(t,  x(:,[11,12,14]+19)/arcsec, 'm'), 
    subplot(325), hold on, xygo('dV');
        plot(t, x1(:,[16:18]+19), ':', 'LineWidth',2);
        plot(t, x2(:,[16:18]+19), '-.', 'LineWidth',2), 
        plot(t,  x(:,[16:18]+19), 'm'), 
end

function POSplot2(x, x1, x2, t)
global glv
    arcmin = glv.min; arcsec = glv.sec; Re = glv.Re; 
    ppm = glv.ppm; ug = glv.ug; dph = glv.dph;
    if nargin<4,  t=1;   end
    if length(t)==1,  t=(1:length(x))'*t;   end
    myfigure;
    subplot(421),  hold on; xygo('phiEN');
        plot(t, x1(:,1:2)/arcsec, ':', 'LineWidth',2),
        plot(t, x2(:,1:2)/arcsec, '-.', 'LineWidth',2), 
        plot(t,  x(:,1:2)/arcsec, 'm'), 
    subplot(422), hold on; xygo('phiU');
        plot(t, x1(:,3)/arcmin, ':', 'LineWidth',2),
        plot(t, x2(:,3)/arcmin, '-.', 'LineWidth',2), 
        plot(t,  x(:,3)/arcmin, 'm'), 
    subplot(423), hold on; xygo('dV');
        plot(t, x1(:,4:6), ':', 'LineWidth',2), 
        plot(t, x2(:,4:6), '-.', 'LineWidth',2), 
        plot(t,  x(:,4:6), 'm'), 
    subplot(424), hold on; xygo('dP');
        plot(t, [x1(:,7)*Re,x1(:,8)*Re,x1(:,9)], ':', 'LineWidth',2),
        plot(t, [x2(:,7)*Re,x2(:,8)*Re,x2(:,9)], '-.', 'LineWidth',2), 
        plot(t, [ x(:,7)*Re, x(:,8)*Re, x(:,9)], 'm'),
    subplot(425), hold on, xygo('eb');
        plot(t, x1(:,10:12)/dph, ':', 'LineWidth',2);
        plot(t, x2(:,10:12)/dph, '-.', 'LineWidth',2), 
        plot(t,  x(:,10:12)/dph, 'm'), 
    subplot(426), hold on, xygo('db');
        plot(t, x1(:,13:15)/ug, ':', 'LineWidth',2);
        plot(t, x2(:,13:15)/ug, '-.', 'LineWidth',2), 
        plot(t,  x(:,13:15)/ug, 'm'), 
    subplot(427), hold on, xygo('L');
        plot(t, x1(:,16:18), ':', 'LineWidth',2);
        plot(t, x2(:,16:18), '-.', 'LineWidth',2), 
        plot(t,  x(:,16:18), 'm'), 
    subplot(428), hold on, xygo('dT');
        plot(t, x1(:,19), ':', 'LineWidth',2);
        plot(t, x2(:,19), '-.', 'LineWidth',2), 
        plot(t,  x(:,19), 'm'), 
if size(x,2)>=34
    myfigure;
    subplot(321), hold on, xygo('dKg');
        plot(t, x1(:,[1,5,9]+19)/ppm, ':', 'LineWidth',2);
        plot(t, x2(:,[1,5,9]+19)/ppm, '-.', 'LineWidth',2), 
        plot(t,  x(:,[1,5,9]+19)/ppm, 'm'), 
    subplot(322), hold on, xygo('dAg');
        plot(t, x1(:,[2,3,6]+19)/arcsec, ':', 'LineWidth',2);
        plot(t, x2(:,[2,3,6]+19)/arcsec, '-.', 'LineWidth',2), 
        plot(t,  x(:,[2,3,6]+19)/arcsec, 'm'), 
    subplot(324), hold on, xygo('dAg');
        plot(t, x1(:,[4,7,8]+19)/arcsec, ':', 'LineWidth',2);
        plot(t, x2(:,[4,7,8]+19)/arcsec, '-.', 'LineWidth',2), 
        plot(t,  x(:,[4,7,8]+19)/arcsec, 'm'), 
    subplot(323), hold on, xygo('dKa');
        plot(t, x1(:,[10,13,15]+19)/ppm, ':', 'LineWidth',2);
        plot(t, x2(:,[10,13,15]+19)/ppm, '-.', 'LineWidth',2), 
        plot(t,  x(:,[10,13,15]+19)/ppm, 'm'), 
    subplot(326), hold on, xygo('dAa');
        plot(t, x1(:,[11,12,14]+19)/arcsec, ':', 'LineWidth',2); 
        plot(t, x2(:,[11,12,14]+19)/arcsec, '-.', 'LineWidth',2),  
        plot(t,  x(:,[11,12,14]+19)/arcsec, 'm'), 
    subplot(325), hold on, xygo('dV');
        plot(t, x1(:,[16:18]+19), ':', 'LineWidth',2);
        plot(t, x2(:,[16:18]+19), '-.', 'LineWidth',2), 
        plot(t,  x(:,[16:18]+19), 'm'), 
end