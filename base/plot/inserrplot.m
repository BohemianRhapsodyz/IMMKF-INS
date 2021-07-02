function inserrplot(err, ptype)
% avp error plot.
%
% Prototype: inserrplot(err, ptype)
% Inputs: err - may be [phi], [phi,dvn], [phi,dvn,dpos],
%                      [phi,dvn,dpos,eb,db], etc.
%         ptype - plot type define
%          
% See also  insplot, kfplot, gpsplot.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 06/10/2013
global glv
    t = err(:,end);
    n = size(err,2)-1;
    if nargin<2
        if n<6,        	ptype = 'a';
        elseif n<9,    	ptype = 'av';
        elseif n<15,   	ptype = 'avp';
        elseif n<18,   	ptype = 'avped';
        elseif n<19,   	ptype = 'avpedl';
        elseif n<21,   	ptype = 'avpedlt';
        elseif n<24,   	ptype = 'avpedlv';
        elseif n<37,    ptype = 'avpedltkgka';
        else            ptype = 'avpedltkgkadv';
        end
    end
    %%
    switch ptype
        case 'a',
            myfigure;
            subplot(211), plot(t,err(:,1:2)/glv.sec), xygo('phiEN');
            subplot(212), plot(t,err(:,3)/glv.min), xygo('phiU');
        case 'av',
            myfigure;
            subplot(221), plot(t, err(:,1:2)/glv.sec); xygo('phiEN');
            subplot(223), plot(t, err(:,3)/glv.min); xygo('phiU');
            subplot(222), plot(t, err(:,4:5)); xygo('dVEN');
            subplot(224), plot(t, err(:,6)); xygo('dVU');
        case 'avp',
            myfigure;
            subplot(221), plot(t, err(:,1:2)/glv.sec); xygo('phiEN'); mylegend('phiE','phiN');
            subplot(222), plot(t, err(:,3)/glv.min); xygo('phiU'); mylegend('phiU');
            subplot(223), plot(t, err(:,4:6)); xygo('dV'); mylegend('dVE','dVN','dVU');
            subplot(224), plot(t, [err(:,7:8)*glv.Re,err(:,9)]); xygo('dP'); mylegend('dlat','dlon','dH');
        case 'avped'
            myfigure;
            subplot(321), plot(t, err(:,1:2)/glv.sec); xygo('phiEN');
            subplot(322), plot(t, err(:,3)/glv.min); xygo('phiU');
            subplot(323), plot(t, err(:,4:6)); xygo('dV');
            subplot(324), plot(t, [err(:,7:8)*glv.Re,err(:,9)]); xygo('dP');
            subplot(325), plot(t, err(:,10:12)/glv.dph); xygo('eb');
            subplot(326), plot(t, err(:,13:15)/glv.ug); xygo('db');
        case 'avpedl'
            myfigure;
            subplot(421), plot(t, err(:,1:2)/glv.sec); xygo('phiEN');
            subplot(422), plot(t, err(:,3)/glv.min); xygo('phiU');
            subplot(423), plot(t, err(:,4:6)); xygo('dV');
            subplot(424), plot(t, [err(:,7:8)*glv.Re,err(:,9)]); xygo('dP');
            subplot(425), plot(t, err(:,10:12)/glv.dph); xygo('eb');
            subplot(426), plot(t, err(:,13:15)/glv.ug); xygo('db');
            subplot(427), plot(t, err(:,16:18)); xygo('L');
        case 'avpedlv'
            myfigure;
            subplot(421), plot(t, err(:,1:2)/glv.sec); xygo('phiEN');
            subplot(422), plot(t, err(:,3)/glv.min); xygo('phiU');
            subplot(423), plot(t, err(:,4:6)); xygo('dV');
            subplot(424), plot(t, [err(:,7:8)*glv.Re,err(:,9)]); xygo('dP');
            subplot(425), plot(t, err(:,10:12)/glv.dph); xygo('eb');
            subplot(426), plot(t, err(:,13:15)/glv.ug); xygo('db');
            subplot(427), plot(t, err(:,16:18)); xygo('L');
            subplot(428), plot(t, err(:,19:21)); xygo('dV');
        case 'avpedlt'
            myfigure;
            subplot(421), plot(t, err(:,1:2)/glv.sec); xygo('phiEN');
            subplot(422), plot(t, err(:,3)/glv.min); xygo('phiU');
            subplot(423), plot(t, err(:,4:6)); xygo('dV');
            subplot(424), plot(t, [err(:,7:8)*glv.Re,err(:,9)]); xygo('dP');
            subplot(425), plot(t, err(:,10:12)/glv.dph); xygo('eb');
            subplot(426), plot(t, err(:,13:15)/glv.ug); xygo('db');
            subplot(427), plot(t, err(:,16:18)); xygo('L');
            subplot(428), plot(t, err(:,19)); xygo('dT');
        case 'kgka'
            myfigure;
            subplot(221), plot(t, err(:,[1,5,9])/glv.ppm); xygo('dKg');
            subplot(322), plot(t, err(:,[2,3,6])/glv.sec); xygo('dAg');
            subplot(324), plot(t, err(:,[4,7,8])/glv.sec); xygo('dAg');
            subplot(223), plot(t, err(:,[10,13,15])/glv.ppm); xygo('dKa');
            subplot(326), plot(t, err(:,[11,12,14])/glv.sec); xygo('dAa');
        case 'kgkadv'
            myfigure;
            subplot(321), plot(t, err(:,[1,5,9])/glv.ppm); xygo('dKg');
            subplot(322), plot(t, err(:,[2,3,6])/glv.sec); xygo('dAg');
            subplot(323), plot(t, err(:,[10,13,15])/glv.ppm); xygo('dKa');
            subplot(324), plot(t, err(:,[4,7,8])/glv.sec); xygo('dAg');
            subplot(325), plot(t, err(:,[16:18])); xygo('dV');
            subplot(326), plot(t, err(:,[11,12,14])/glv.sec); xygo('dAa');
        case 'avpedltkgka'
            inserrplot([err(:,1:19),t], 'avpedlt');
            inserrplot([err(:,20:34),t], 'kgka');
        case 'avpedltkgkadv'
            inserrplot([err(:,1:19),t], 'avpedlt');
            inserrplot([err(:,20:37),t], 'kgkadv');
        case 'avped_od'
            inserrplot(err(:,1:15), t, 'avped');
            myfigure;
            subplot(311), plot(t, err(:,[16,18])/glv.deg); xygo('drInst / deg');
            subplot(312), plot(t, err(:,[17])); xygo('dKD');
            subplot(313), plot(t, err(:,[19:21])); xygo('Lever / m');
        case 'avped_od_dt'
            inserrplot(err(:,1:15), t, 'avped');
            myfigure;
            subplot(221), plot(t, err(:,[16,18])/glv.deg); xygo('drInst / deg');
            subplot(223), plot(t, err(:,[17])); xygo('dKD'); xlgo
            subplot(222), plot(t, err(:,[19:21])); xygo('Lever / m');
            subplot(224), plot(t, err(:,22)); xygo('dt / s');
        case 'DR'
            myfigure;
            err = err(:,4:6)-err(:,7:9);
            subplot(321), plot(t, err(:,1:2)/glv.sec); xygo('phiEN');
            subplot(322), plot(t, err(:,3)/glv.min); xygo('phiU');
            subplot(323), plot(t, err(:,1:2)*glv.Re); ylabel('\it\delta L,\delta\lambda\rm / m'); xlgo
            subplot(325), plot(t, err(:,3)); ylabel('\it\delta h\rm / m'); xlgo
            subplot(3,2,[4,6]), plot(err(:,5)/glv.deg, err(:,4)/glv.deg);
            hold on, plot(err(:,8)/glv.deg, err(:,7)/glv.deg, 'r'); xlabel('\it\lambda\rm / \circ'); ylabel('\itL\rm / \circ'); grid on;  
    end
