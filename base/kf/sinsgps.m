function [avp, xkpk, ins, kf] = sinsgps(imu, gps, ins, davp, imuerr, lever, r0, fbstr)
% %% init
% imuerr = imuerrset(0.03, 100, 0.001, 1);
% davp = avpseterr([300;300;300], [1;1;1], [1;1;3]*100);
% ins = insinit(avp(1,1:9), ts); ins.nts=nts;
% %% kf
% lever = [0;0;0];
% rk = [10/glv.Re;10/glv.Re;30];
% [avp1, xkpk, ins, kf] = sinsgps(imu, gps, ins, davp, imuerr, lever, rk, 'avp');
global glv
    if ~exist('fbstr', 'var'), fbstr='avp'; end
    [nn, ts, nts] = nnts(2, diff(imu(1:2,end)));
    gpspos_only = 0;
    if size(gps,2)<=5, gpspos_only = 1; end 
    psinstypedef(186);
    kf = [];
    kf.Qt = diag([imuerr.web; imuerr.wdb; zeros(3,1); imuerr.sqg; imuerr.sqa; zeros(3,1)])^2;
    kf.Rk = diag(r0)^2;
    kf.Pxk = diag([davp; imuerr.eb; imuerr.db; lever]*1.0)^2;
    kf.Pmin = [[3;3;10]*glv.min; [0.01;0.01;0.01]; [[1;1]/glv.Re;1]; [5;5;5]*glv.dph; [100;100;100]*glv.ug; [0;0;0]].^2;
    kf.Pmax = 100*diag(kf.Pxk); kf.pconstrain = 1; % kf.adaptive = 1;
%     kf.xtau = [ [1;1;1]*10; [1;1;1]; [1;1;1]; [10;10;10]; [10;10;10]; [1;1;1] ];
    kf.Hk = zeros(length(r0),18);
    kf = kfinit0(kf, nts);
    imugpssyn(imu(:,7), gps(:,end));
    len = length(imu); [avp, xkpk] = prealloc(fix(len/nn), 16, 2*kf.n+1);
    timebar(nn, len, '18-state SINS/GPS simulation.'); ki = 1;
    kfs = kfstatistic(kf);    kfs1 = kfstat([],kf);
    for k=1:nn:len-nn+1
        k1 = k+nn-1; 
        wvm = imu(k:k1,1:6); t = imu(k1,end);
        ins = insupdate(ins, wvm);
        kf.Phikk_1 = kffk(ins);  % kf.Phikk_1(1:3,1:3) = eye(3);
        kf = kfupdate(kf);
%         kfs = kfstatistic(kfs, kf, 'T');   kfs1 = kfstat(kfs1, kf, 'T');
        [kgps, dt] = imugpssyn(k, k1, 'F');
        if kgps>0
%             if gps(kgps,4)<4 && gps(kgps,4)>0   % DOP
                ins = inslever(ins);
                if gpspos_only==1
                    zk = ins.posL-gps(kgps,1:3)'; 
                    kf.Hk = [zeros(3,6), eye(3), zeros(3,6), -ins.MpvCnb];
                else
                    zk = [ins.vnL;ins.posL]-gps(kgps,1:6)';
                    kf.Hk = [zeros(6,3), eye(6), zeros(6,6), [-ins.CW;-ins.MpvCnb]];
                end
                kf = kfupdate(kf, zk, 'M');
    %             kfs = kfstatistic(kfs, kf, 'M');     kfs1 = kfstat(kfs1, kf, 'M');
%             end
        end
                [kf, ins] = kffeedback(kf, ins, nts, fbstr);
        avp(ki,:) = [ins.avp; ins.eb; ins.db; t]';
        xkpk(ki,:) = [kf.xk; diag(kf.Pxk); t]'; ki = ki+1;
        timebar;
    end
%     kfs = kfstatistic(kfs);    kfs1 = kfstat(kfs1,kf);
    avp(ki:end,:) = []; xkpk(ki:end,:) = [];
    insplot(avp);
    kfplot(xkpk);

