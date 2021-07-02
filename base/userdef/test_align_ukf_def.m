function out = test_align_ukf_def(tag, varargin)
% See also  kfinit, kffk, kfhk, kfplot.
global glv psinsdef
switch tag
	case psinsdef.kfinittag,
        [nts, imuerr] = setvals(varargin);
        kf.fx = @afamodel;
        kf.Qk = diag([imuerr.web; imuerr.wdb])^2*nts;
        kf.Rk = diag([0.1;0.1;0.1])^2;
        kf.Pxk = diag([[10;10;180]*glv.deg; [1;1;1]])^2;
        kf.Hk = [zeros(3), eye(3)];
        out = kf;
    case psinsdef.kffktag,
    case psinsdef.kfhktag,
    case psinsdef.kfplottag,
        [xkpk, res] = setvals(varargin);
        t = xkpk(:,end);
        myfigure
        subplot(321), plot(t, [res(:,1:2),xkpk(:,1:2)]/glv.deg), xygo('phixy');
        subplot(323), plot(t, [res(:,3),xkpk(:,3)]/glv.deg), xygo('phiz');
        subplot(325), plot(t, [res(:,4:6),xkpk(:,4:6)]), xygo('dV');
        subplot(322), plot(t, sqrt(xkpk(:,7:8))/glv.deg), xygo('phixy');
        subplot(324), plot(t, sqrt(xkpk(:,9))/glv.deg), xygo('phiz');
        subplot(326), plot(t, sqrt(xkpk(:,10:12))), xygo('dV');
end
