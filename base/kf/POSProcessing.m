function ps = POSProcessing(kf, ins, imu, vpGPS, fbstr, ifbstr)
% POS forward and backward data processing.
%
% Prototype: ps = POSProcessing(kf, ins, imu, posGPS, fbstr, ifbstr)
% Inputs: kf - Kalman filter structure array from kfinit
%         ins - SINS structure array from insinit
%         imu - SIMU data including [wm, vm, t]
%         vpGPS - GPS velocity & position [lat, lon, heigth, tag, tSecond]
%                 or [vE, vN, vU, lat, lon, heigth, tag, tSecond], where
%                 'tag' may be omitted.
%         fbstr,ifbstr - Kalman filter feedback indicator for
%               forward and backward processing.
% Output: ps - a structure array, the fields are
%             avp,xkpk  - forward processing avp, state estimation and
%                         variance
%             iavp,ixkpk  - backward processing avp, state estimation and
%                         variance
%
% See also  insupdate, kfupdate, POSFusion, posplot.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 22/01/2014, 08/02/2015
    if ~exist('fbstr','var'),  fbstr = 'avp';  end
    if ~exist('ifbstr','var'),  ifbstr = fbstr;  end
    len = length(imu); [lenGPS,col] = size(vpGPS);
    if col==4||col==7, vpGPS = [vpGPS(:,1:end-1),ones(lenGPS,1),vpGPS(:,end)]; end % add tag
    imugpssyn(imu(:,7), vpGPS(:,end));
    ts = ins.ts; nts = kf.nts; nn = round(nts/ts);
    dKga = zeros(15,1);
    %% forward navigation
	[avp, xkpk] = prealloc(ceil(len/nn), kf.n+1, 2*kf.n+1); ki = 1;
    Qk = zeros(fix(length(avp)/100*nn)-1, kf.n+1);  Rk = zeros(fix(length(avp)/100*nn)-1, 8);  kki = 1;
    timebar(nn, len, 'SINS/GPS POS forward processing.');
    for k=1:nn:(len-nn+1)
        k1 = k+nn-1; wvm = imu(k:k1,1:6); t = imu(k1,7);
        ins = insupdate(ins, wvm);
        kf.Phikk_1 = kffk(ins);
%         kf.Phikk_1 = ekffk(ins, kf.xk(1:3));
        kf = kfupdate(kf);
        [kgps, dt] = imugpssyn(k, k1, 'F');
        if kgps>0 
            if vpGPS(kgps,end-1)>=1 % tag OK
                ins = inslever(ins);
                kf.Hk = kfhk(ins);
                if size(kf.Hk,1)==6
                    zk = [ins.vnL-ins.an*dt; ins.posL-ins.Mpvvn*dt]-vpGPS(kgps,1:6)';
%                     zk = [ins.vn-ins.an*dt; ins.pos-ins.Mpvvn*dt]-vpGPS(kgps,1:6)';
                else
                    zk = ins.pos-ins.Mpvvn*dt-vpGPS(kgps,1:3)';
                end
%             	kf = kfupdate(kf, zk, 'M');
            	kf = kfupdatesq(kf, zk, 'M');
            end
            Qk(kki,:) = [diag(kf.Qk); t]';
%             Rk(kki,:) = [diag(kf.Rk); kf.beta; t]';  kki = kki+1;
        end
%         if k>125*60, fbstr = 'p'; end
        [kf, ins] = kffeedback(kf, ins, nts, fbstr);
        dKg = ins.Kg-eye(3); dKa = ins.Ka-eye(3);
        dKga = [dKg(:,1);dKg(:,2);dKg(:,3); dKa(:,1);dKa(2:3,2);dKa(3,3)];
        avp(ki,:) = [ins.avp; ins.eb; ins.db; ins.lever; ins.tDelay; dKga; [0;0;0]; t]';
        xkpk(ki,:) = [kf.xk; diag(kf.Pxk); t]';  ki = ki+1;
        timebar;
    end
    avp(ki:end,:)=[]; xkpk(ki:end,:)=[]; Qk(kki:end,:)=[];  Rk(kki:end,:)=[];
    ps.avp = avp; ps.xkpk = xkpk; ps.Qk = [sqrt(Qk(:,1:end-1)),Qk(:,end)];  ps.Rk = [sqrt(Rk(:,1:6)),Rk(:,7:8)];
    %% reverse navigation
%     glv.wie = -abs(glv.wie);
    [ikf, iins, idx] = POSReverse(kf, ins);
    [iavp, ixkpk] = prealloc(ceil(len/nn), kf.n+1, 2*kf.n+1); ki = 1;
    timebar(nn, len, 'SINS/GPS POS backward processing.');
    for k=k1:-nn:(1+nn)
        ik1 = k-nn+1; wvm = imu(k:-1:ik1,1:6); wvm(:,1:3) = -wvm(:,1:3); t = imu(ik1-1,7);
        iins = insupdate(iins, wvm);
        ikf.Phikk_1 = kffk(iins);
        ikf = kfupdate(ikf);
        [kgps, dt] = imugpssyn(ik1, k, 'B');
        if kgps>0 
            if vpGPS(kgps,end-1)>1 % tag OK
                iins = inslever(iins);
                ikf.Hk = kfhk(iins);
                if size(ikf.Hk,1)==6
                    zk = [iins.vn-iins.an*dt; iins.pos-iins.Mpvvn*dt]-[-vpGPS(kgps,1:3),vpGPS(kgps,4:6)]';
                else
                    zk = iins.pos-iins.Mpvvn*dt-vpGPS(kgps,1:3)';
                end
            	ikf = kfupdate(ikf, zk, 'M');
%             	kf = akf(kf, zk, 'M');
            end
        end
        [ikf, iins] = kffeedback(ikf, iins, nts, ifbstr);
        dKg = iins.Kg-eye(3); dKa = iins.Ka-eye(3);
        dKga = [dKg(:,1);dKg(:,2);dKg(:,3); dKa(:,1);dKa(2:3,2);dKa(3,3)];
%         [ikf, iins] = kffeedback(ikf, iins, nts, ifbstr); % for imu reverse gen
        iavp(ki,:) = [iins.avp; iins.eb; iins.db; iins.lever; iins.tDelay; dKga; [0;0;0]; t]';
        ixkpk(ki,:) = [ikf.xk; diag(ikf.Pxk); t]';  ki = ki+1;
        timebar;
    end
    iavp(ki:end,:)=[]; ixkpk(ki:end,:)=[];  
    iavp = flipud(iavp); ixkpk = flipud(ixkpk); % reverse inverse sequence
    iavp(:,idx) = -iavp(:,idx);  ixkpk(:,idx) = -ixkpk(:,idx);
    ps.avp = avp; ps.xkpk = xkpk; ps.iavp = iavp; ps.ixkpk = ixkpk;
%     glv.wie = abs(glv.wie); 

    
function [ikf, iins, idx] = POSReverse(kf, ins)
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 22/01/2014
    iins = ins;
    iins.eth.wie = -iins.eth.wie;
    iins.vn = -iins.vn; iins.eb = -iins.eb; iins.tDelay = -iins.tDelay;
    ikf = kf;
    ikf.Pxk = 10*ikf.Pxk;
    idx = [4:6,10:12,19,35:37];   % vn,eb,dT,dvn  (dKg no reverse!)
    ikf.xk(idx) = -ikf.xk(idx); % !!!
    