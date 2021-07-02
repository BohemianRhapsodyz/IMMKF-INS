function c = cep(posINS, posGPS, t)
% Calculating CEP.
%
% Prototype: c = cep(posINS, posGPS, t))
% Inputs: posINS - SINS position data [lat,lon,hgt,t]
%         posGPS - GPS refference position data
%         t  - statical time point
% Output: c - CEP value
%
% See also  avpcmp.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 20/04/2018
global glv
    if nargin==1
        posGPS = posINS(1,1:3)';
    end
    if size(posGPS,2)==1  % static INS, posGPS is fix
        t = posINS(:,end);
        posGPS = [repmat(posGPS',size(posINS,1),1),t];
    end
    posINS = interp1(posINS(:,end), posINS(:,1:3), t);
    posGPS = interp1(posGPS(:,end), posGPS(:,1:3), t);
    err = posINS - posGPS;
    err = [err(:,1)*glv.Re,err(:,2)*glv.Re*cos(posGPS(1,1)),err(:,3)];
    r = rms(err);
    c = 0.5887*(r(1)+r(2));
    myfigure
    subplot(211)
    plot(t, err(:,1:2), '-*'); xygo('Horizontal err / m'); legend('Latitude error', 'Longitude error');
    title(sprintf('CEP = %.3f / m',c));
    subplot(212)
    plot(t, err(:,3), '-*'); xygo('Height err / m'); legend('Height error');

