function out = test_align_transfer_def(tag, varargin)
% See also  kfinit, kffk, kfhk, kfplot.
global glv psinsdef
switch tag
	case psinsdef.kfinittag,
        [nts, imuerr, beta, Q] = setvals(varargin);
        kf.Phikk_1 = eye(21); 
        kf.Phikk_1(16:18,19:21) = eye(3)*nts; 
        kf.Phikk_1(19:21,16:21) = [-diag(beta)^2*nts, -2*diag(beta)*nts+eye(3)];
        kf.Hk = [eye(6), zeros(6,15)]; 
        kf.Qk = diag([imuerr.web; imuerr.wdb; zeros(12,1); sqrt(Q)])^2*nts;
        kf.Rk = diag([[1;1;1]*glv.min; [.1;.1;.1]])^2;
        kf.Pxk = diag([[10;10;10]*glv.deg; [10;10;10]; imuerr.eb; imuerr.db; ...
                    [10;10;10]*glv.deg; [1;1;1]*glv.deg; [10;10;10]*glv.dps])^2;
        out = kf;
    case psinsdef.kffktag,
    case psinsdef.kfhktag,
    case psinsdef.kfplottag,
        [xkpk, res, imuerr, mub, thetak, omegak] = setvals(varargin);
        t = xkpk(:,end); len = length(t);
        myfigure,
        subplot(421),plot(t, xkpk(:,1:3)/glv.min), xygo('phi'), plot(t,res(:,1:3)/glv.min,'-.'),
        subplot(422),plot(t, xkpk(:,4:6)), xygo('dV');          plot(t,res(:,4:6),'-.'),
        subplot(423),plot(t, xkpk(:,7:9)/glv.dph), xygo('eb'),  plot(t,repmat(imuerr.eb,1,len)/glv.dph,'-.'),
        subplot(424),plot(t, xkpk(:,10:12)/glv.ug), xygo('db'), plot(t,repmat(imuerr.db,1,len)/glv.ug,'-.'),
        subplot(425),plot(t, xkpk(:,13:15)/glv.min), xygo('mu'), plot(t,repmat(mub,1,len)/glv.min,'-.'),
        subplot(426),plot(t, xkpk(:,16:18)/glv.min), xygo('theta'), plot(t,thetak/glv.min,'-.'),
        subplot(427),plot(t, xkpk(:,19:21)/glv.dps), xygo('w'),  plot(t,omegak/glv.dps,'-.'),
        myfigure,
        xkpk(:,21+[1:21]) = sqrt(xkpk(:,21+[1:21]));
        subplot(421),plot(t, xkpk(:,21+[1:3])/glv.min), xygo('phi');
        subplot(422),plot(t, xkpk(:,21+[4:6])), xygo('dV');
        subplot(423),plot(t, xkpk(:,21+[7:9])/glv.dph), xygo('eb');
        subplot(424),plot(t, xkpk(:,21+[10:12])/glv.ug), xygo('db');
        subplot(425),plot(t, xkpk(:,21+[13:15])/glv.min), xygo('mu');
        subplot(426),plot(t, xkpk(:,21+[16:18])/glv.min), xygo('theta');
        subplot(427),plot(t, xkpk(:,21+[19:21])/glv.dps), xygo('w');
end
