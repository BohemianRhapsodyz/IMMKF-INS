function out = test_GPS_INS_tight_def(tag, varargin)
% See also  kfinit, kffk, kfhk, kfplot.
global glv psinsdef
switch tag
	case psinsdef.kfinittag,
        [nts, davp, imuerr] = setvals(varargin);
        Qt = diag([imuerr.web; imuerr.wdb; zeros(3,1); imuerr.sqg; imuerr.sqa; zeros(6,1)])^2;
        kf.Qk = Qt*nts;
        kf.Pxk = diag([davp; imuerr.eb; imuerr.db; [1;1;1]*1; 0.01; 100; 1])^2;
        kf.Hk = zeros(1,21);  kf.Rk = zeros(1);
        kf.Rk = diag([0.1;0.1;0.3; 10/glv.Re;10/glv.Re;30])^2;
        kf.xtau(1:21,1) = 0; kf.xtau(1:3) = 10; kf.xtau(4:9) = 1.0; kf.xtau(10:15) = 10.0;
%         kf.s = 1.01;
%         kf.adaptive = 1;
        out = kf;
    case psinsdef.kffktag,
        % 1-15: INS error; 16-18: lever arm; 19: Tasyn; 20-21: clock bias & drift
        ins = varargin{1}{1};
        Ft = etm(ins);   Ft(21,21) = 0;
        Ft(20,21) = 1;
        out = Ft;
    case psinsdef.kfhktag,
        [ins, LOS] = setvals(varargin);
        m = size(LOS,1);
        LT = LOS*Dblh2Dxyz(ins.pos);
        LC = LOS*p2cne(ins.pos)';
%       kf.Hk = [zeros(6,3), eye(6), zeros(6,6), [ins.CW,-ins.an;ins.MpvCnb,-ins.Mpvvn], zeros(6,2)];   
        Hk = [ zeros(m,6),  LT, zeros(m,6),  LT*ins.MpvCnb, -LT*ins.Mpvvn, ones(m,1),  zeros(m,1); 
         	   zeros(m,3), -LC, zeros(m,9), -LC*ins.CW,      LC*ins.an,    zeros(m,1), ones(m,1) ];
        out = Hk;
    case psinsdef.kfplottag,
        [xkpk, avp, avpgps] = setvals(varargin);
        avpgps = [zeros(size(avpgps(:,1:3))), avpgps];
        t0 = xkpk(1,end);  xkpk(:,end) = xkpk(:,end)-t0;  avp(:,end) = avp(:,end)-t0; avpgps(:,10) = avpgps(:,10)-t0;
        insplot(avp);   % avp
        subplot(323), plot(avpgps(:,10), avpgps(:,4:6), 'm');
        subplot(325), plot(avpgps(:,10), [[avpgps(:,7)-avp(1,7),(avpgps(:,8)-avp(1,8))*cos(avp(1,7))]*glv.Re,avpgps(:,9)-avp(1,9)], 'm');
        subplot(3,2,[4,6]), plot((avpgps(:,8)-avp(1,8))*glv.Re*cos(avp(1,7)), (avpgps(:,7)-avp(1,7))*glv.Re);
        inserrplot(xkpk(:,[1:19,end]), 'avpedlt');   % err
        inserrplot([sqrt(xkpk(:,22:22+18)),xkpk(:,end)], 'avpedlt');
        myfigure  % clk bias
        subplot(221), plot(xkpk(:,end), xkpk(:,20)); xygo('dt(m)');
        	plot(avpgps(:,10),avpgps(:,11), 'm');
        subplot(223), plot(xkpk(:,end), xkpk(:,21)); xygo('dtDot(m/s)');
        	plot(avpgps(:,10),avpgps(:,12), 'm');
        subplot(222), plot(xkpk(:,end), sqrt(xkpk(:,41))); xygo('dt(m)');
        subplot(224), plot(xkpk(:,end), sqrt(xkpk(:,42))); xygo('dtDot(m/s)');
end
