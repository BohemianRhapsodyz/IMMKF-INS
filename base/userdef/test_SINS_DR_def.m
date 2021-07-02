function out = test_SINS_DR_def(tag, varargin)
% See also  kfinit, kffk, kfhk, kfplot.
global glv psinsdef
switch tag
	case psinsdef.kfinittag,
        [nts, davp, imuerr, dinst, dKod, dT] = setvals(varargin);
        kf.Qt = diag([imuerr.web; imuerr.wdb; zeros(9+3+4*1,1)])^2;
        kf.Rk = diag(davp(7:9))^2;
        kf.Pxk = diag([davp; imuerr.eb; imuerr.db; davp(7:9); dinst([1,3])*glv.min; dKod; dT]*10)^2;
        kf.Hk = zeros(3,22); kf.Hk(:,7:9) = eye(3); kf.Hk(:,16:18) = -eye(3);
        out = kf;
    case psinsdef.kffktag,
        % SINS/DR: INS(15)+dposD(3)+dpitch/dyaw(2)+dKod(1)+dT(1)=22
        ins = varargin{1}{1};
        Ft = etm(ins);   Ft(22,22) = 0;
        Mpp = Ft(7:9,7:9);
        Mpvvn = ins.Mpv*ins.vn;
        Mpvvnx = ins.Mpv*askew(ins.vn);
        MpvvnxCnb = Mpvvnx*ins.Cnb;
        Ft(16:18,[1:3,16:18,19:20,21]) = [Mpvvnx,Mpp,MpvvnxCnb(:,[1,3]),Mpvvn];
        out = Ft;
    case psinsdef.kfhktag,
    case psinsdef.kfplottag,
        [xkpk, avp, insavp, dravp, imuerr, dinst, dkod, dT] = setvals(varargin);
        insavperr = avpcmp(insavp, avp);
        dravperr = avpcmp(dravp, avp);
        tt = xkpk(:,end); len = length(tt);
        inserrplot([xkpk(:,1:15),tt]);
        subplot(321), hold on, plot(tt, insavperr(:,1:2)/glv.sec, 'm--');
        subplot(322), hold on, plot(tt, insavperr(:,3)/glv.min, 'm--');
        subplot(323), hold on, plot(tt, insavperr(:,4:6), 'm--');
        subplot(324), hold on, plot(tt, [insavperr(:,7:8)*glv.Re,insavperr(:,9)], 'm--');
        subplot(325), hold on, plot(tt, repmat(imuerr.eb'/glv.dph,len,1), 'm--');
        subplot(326), hold on, plot(tt, repmat(imuerr.db'/glv.ug,len,1), 'm--');
        myfigure,
        subplot(221), plot(tt, [xkpk(:,16:17)*glv.Re,xkpk(:,18)]), xygo('dP')
            hold on,  plot(tt, [dravperr(:,7:8)*glv.Re,dravperr(:,9)], 'm--');
        subplot(222), plot(tt, xkpk(:,19:20)/glv.min), xygo('dinst')
            hold on,  plot(tt, repmat(dinst([1,3])',len,1), 'm--');
        subplot(223), plot(tt, xkpk(:,21)), xygo('dkod');
            hold on,  plot(tt, repmat(dkod,len,1), 'm--');
        subplot(224), plot(tt, xkpk(:,22)), xygo('dT');
            hold on,  plot(tt, repmat(dT,len,1), 'm--');
        xkpk = [sqrt(xkpk(:,23:end-1)),xkpk(:,end)];
        inserrplot([xkpk(:,1:15),tt]);
        myfigure,
        subplot(221), plot(tt, [xkpk(:,16:17)*glv.Re,xkpk(:,18)]), xygo('dP')
        subplot(222), plot(tt, xkpk(:,19:20)/glv.min), xygo('dinst')
        subplot(223), plot(tt, xkpk(:,21)), xygo('dkod');
        subplot(224), plot(tt, xkpk(:,22)), xygo('dT');
end
