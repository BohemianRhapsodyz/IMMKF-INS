function insplot(avp, ptype, varargin)
% avp plot.
%
% Prototype: insplot(avp, ptype)
% Inputs: avp - may be [att], [att,vn] or [att,vn,pos]
%         ptype - plot type define
%          
% See also  inserrplot, kfplot, gpsplot, imuplot, pos2dxyz.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 06/10/2013, 09/11/2018
global glv
    t = avp(:,end);
    n = size(avp,2);
    if nargin<2
        if n<5,  	 ptype = 'a';
        elseif n<8,	 ptype = 'av';
        elseif n<11, ptype = 'avp';
        elseif n<17, ptype = 'avped';
        elseif n<20, ptype = 'avpedl';
        else         ptype = 'avpedlt';
        end
    end
    %%
    switch ptype
        case 'a',
            myfigure;
            subplot(211), plot(t, avp(:,1:2)/glv.deg), xygo('pr');
            subplot(212), plot(t, avp(:,3)/glv.deg), xygo('y');
        case 'av',
            myfigure;
            subplot(221), plot(t, avp(:,1:2)/glv.deg); xygo('pr');
            subplot(223), plot(t, avp(:,3)/glv.deg); xygo('y');
            subplot(222), plot(t, avp(:,4:5)); xygo('VEN');
            subplot(224), plot(t, avp(:,6)); xygo('VU');
        case 'avp',
            if size(avp,2)==9, t=1:length(t); end
            myfigure;
            subplot(321), plot(t, avp(:,1:2)/glv.deg); xygo('pr');
            subplot(322), plot(t, avp(:,3)/glv.deg); xygo('y');
            subplot(323), plot(t, [avp(:,4:6),sqrt(avp(:,4).^2+avp(:,5).^2+avp(:,6).^2)]); xygo('V');
            dxyz = dposxyz(avp(:,7:9));
            subplot(325), plot(t, dxyz(:,1:3)); xygo('DP');
%             subplot(325), plot(t, [[avp(:,7)-avp(1,7),(avp(:,8)-avp(1,8))*cos(avp(1,7))]*glv.Re,avp(:,9)-avp(1,9)]); xygo('DP');
%             subplot(3,2,[4,6]), plot(r2d(avp(:,8)), r2d(avp(:,7))); xygo('lon', 'lat');
%                 hold on, plot(r2d(avp(1,8)), r2d(avp(1,7)), 'rp');
            subplot(3,2,[4,6]), plot(0, 0, 'rp');   % 19/04/2015
                hold on, plot(dxyz(:,2), dxyz(:,1)); xygo('est', 'nth');
%                 hold on, plot((avp(:,8)-avp(1,8))*glv.Re*cos(avp(1,7)), (avp(:,7)-avp(1,7))*glv.Re); xygo('est', 'nth');
            legend(sprintf('%.6f, %.6f / DMS', r2dms(avp(1,8))/10000,r2dms(avp(1,7))/10000));
        case 'avped'
            myfigure;
            subplot(321), plot(t, avp(:,1:2)/glv.deg); xygo('pr');
            subplot(322), plot(t, avp(:,3)/glv.deg); xygo('y');
            subplot(323), plot(t, [avp(:,4:6),normv(avp(:,4:6))]); xygo('V');
            dxyz = dposxyz(avp(:,7:9));
            subplot(324), plot(t, dxyz(:,1:3)); xygo('DP');
%             subplot(324), plot(t, [[avp(:,7)-avp(1,7),(avp(:,8)-avp(1,8))*cos(avp(1,7))]*glv.Re,avp(:,9)-avp(1,9)]); xygo('DP');
            subplot(325), plot(t, avp(:,10:12)/glv.dph); xygo('eb');
            subplot(326), plot(t, avp(:,13:15)/glv.ug); xygo('db');
        case 'avpedl'
            myfigure;
            subplot(421), plot(t, avp(:,1:2)/glv.deg); xygo('pr');
            subplot(422), plot(t, avp(:,3)/glv.deg); xygo('y');
            subplot(423), plot(t, [avp(:,4:6),normv(avp(:,4:6))]); xygo('V');
            dxyz = dposxyz(avp(:,7:9));
            subplot(424), plot(t, dxyz(:,1:3)); xygo('DP');
            subplot(425), plot(t, avp(:,10:12)/glv.dph); xygo('eb');
            subplot(426), plot(t, avp(:,13:15)/glv.ug); xygo('db');
            subplot(427), plot(t, avp(:,16:18)); xygo('L');
        case 'avpedlt'
            insplot(avp, 'avpedl');
            subplot(428), plot(t, avp(:,19)); xygo('dT');
        case 'DR',
            avptrue = setvals(varargin);
            myfigure;
            subplot(321), plot(t, avp(:,1:2)/glv.deg); xygo('pr');
            subplot(322), plot(t, avp(:,3)/glv.deg); xygo('y');
            subplot(323), plot(t, [avp(:,4:6),normv(avp(:,4:6))]); xygo('V');
            dxyz = dposxyz(avp(:,7:9));
            subplot(325), plot(t, dxyz(:,1:3)); xygo('DP');
%             subplot(325), plot(t, [[avp(:,7)-avp(1,7),(avp(:,8)-avp(1,8))*cos(avp(1,7))]*glv.Re,avp(:,9)-avp(1,9)]); xygo('DP');
            subplot(3,2,[4,6]), plot(r2d(avp(:,8)), r2d(avp(:,7))); xygo('lon', 'lat');
                hold on, plot(r2d(avptrue(:,8)), r2d(avptrue(:,7)), 'r-');
                plot(r2d(avp(1,8)), r2d(avp(1,7)), 'rp');
            legend('DR trajectory', 'True trajectory', 'Location','Best');
    end
        