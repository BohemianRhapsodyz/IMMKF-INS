function out = test_align_ekf_def(tag, varargin)
% See also  kfinit, kffk, kfhk, kfplot.
global glv psinsdef
switch tag
	case psinsdef.kfinittag,
        [nts, phi0, imuerr, eth] = setvals(varargin);
        kf.Qk = diag([imuerr.web; imuerr.wdb(1:2)])^2*nts;
        kf.Rk = diag([0.1;0.1])^2;
        kf.Pxk = diag([phi0; [1;1]])^2;
        kf.Hk = [zeros(2,3), eye(2)];
        wN = eth.wnie(2); wU = eth.wnie(3); g = -eth.gn(3);
        Ft = [ 0,   wU, -wN, 0, 0;   % for linear Kalman filter
              -wU,  0,   0,  0, 0;
               wN,  0,   0,  0, 0;
               0,  -g,   0,  0, 0;
               g,   0,   0,  0, 0 ];
        kf.Phikk_1 = eye(5)+Ft*nts;
        out = kf;
    case psinsdef.kffktag,
    case psinsdef.kfhktag,
    case psinsdef.kfplottag,
        [reskf, resekf] = setvals(varargin);
        t = reskf(:,end);
        myfigure;
        subplot(321); plot(t, [reskf(:,1),resekf(:,1)]/glv.min); xygo('phiE');
        subplot(323); plot(t, [reskf(:,2),resekf(:,2)]/glv.min); xygo('phiN');
        subplot(325); plot(t, [reskf(:,3),resekf(:,3)]/glv.min); xygo('phiU'); legend('Linear Kalman', 'EKF');
        subplot(322); plot(t, [reskf(:,4),resekf(:,4)]), xygo('dVE');
        subplot(324); plot(t, [reskf(:,5),resekf(:,5)]), xygo('dVN');
end
