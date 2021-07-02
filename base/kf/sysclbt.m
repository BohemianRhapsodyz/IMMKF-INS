function [clbt, av] = sysclbt(imu, pos, g0, Cba)
% SIMU systemtic calibration processing under specific rotating operation.
%
% Prototype: clbt = sysclbt(imu, pos, g0, Cba)
% Inputs: imu - SIMU data after coarse calibration
%         pos - geographical position = [latitude; longitude; height]
%         g0  - local gravity magnitude
%         Cba - accelerometer installation direction matrix, always I3x3.
% Output: clbt - SIMU fine calibration result array after this porcessing,
%               inculde fields:
%                 'Kg, Ka, eb, db, Ka2, rx, ry, rz, tGA', such that
%                 wm = Kg*wm - eb*ts
%                 vm = Ka*vm - (db+Ka2.*fb.^2+fL+tGA*wbXfb)*ts
%                where wb=wm/ts, fb=vm/ts, and fL is accelerometer inner
%                lever arm effect (refer to the following code). 
%
% See also  imuerrset, insupdate, kfupdate.

% Copyright(c) 2009-2016, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 17/08/2016
global glv
    if nargin<4, Cba=eye(3); end
    if nargin<3, eth=earth(pos); g0=eth.g; end
    [nn,ts,nts] = nnts(2, diff(imu(1:2,end)));  frq2 = fix(1/ts/2)-1;
    for k=(frq2+1):(2*frq2):(5*60*2*frq2)
        ww = mean(imu(k-frq2:k+frq2,1:3),1); ww = norm(ww)/ts;
        if ww>20*glv.dph, break; end
    end
    if k<10*frq2,  error('Not find static state in the first 5 second to make valid INS alignment.'); end
    kstatic = k-3*frq2;
    wnie = glv.wie*[0;cos(pos(1));sin(pos(1))]; gn = [0;0;-g0];
    clbt.Kg = eye(3); clbt.Ka = eye(3); clbt.Ka2 = zeros(3,1); clbt.eb = zeros(3,1); clbt.db = zeros(3,1);
    clbt.rx = zeros(3,1); clbt.ry = zeros(3,1); clbt.rz = zeros(3,1); clbt.tGA = 0;
    len = length(imu);  imu1 = imu;
    itertion = 5;
    for iter=1:itertion
        imu1(:,1:6) = [imu(:,1:3)*clbt.Kg', imu(:,4:6)*clbt.Ka'];    % IMU calibration for alignment
        imu1(:,1:6) = [imu1(:,1)-clbt.eb(1)*ts,imu1(:,2)-clbt.eb(2)*ts,imu1(:,3)-clbt.eb(3)*ts, ...  % 20181102
                       imu1(:,4)-clbt.db(1)*ts,imu1(:,5)-clbt.db(2)*ts,imu1(:,6)-clbt.db(3)*ts];
        [~, qnb] = alignsb(imu1(frq2:kstatic,:), pos); vn = zeros(3,1);  % align
%         if iter==1, qnb0 = qnb;  else, qnb0 = qdelphi(qnb0, kf.xk(1:3)); end
%         att = q2att(qnb); att0 = q2att(qnb0); qnb = a2qua([att(1:2);att0(3)]);
        dotwf = imudot(imu1, 5.0);
        if iter~=itertion,  kf = clbtkfinit(nts);  else, kf.Pxk = kf.Pxk*100; kf.Pxk(:,3)=0; kf.Pxk(3,:)=0; kf.xk = kf.xk*0; end
        t1s = 0; vn1s = zeros(fix(len*ts), 4);  kkv = 1;
        av = zeros(fix(len*ts),7); xkpk = zeros(fix(len*ts), kf.n*2+1);  kk = 1;
        timebar(nn, len-2*frq2, sprintf('System Calibration of SIUM( iter=%d ).',iter));
        for k=2*frq2:nn:len-frq2
            k1 = k+nn-1;
            wm = imu(k:k1,1:3); vm = imu(k:k1,4:6); t = imu(k1,end); dwb = mean(dotwf(k:k1,1:3),1)';
            [phim, dvbm] = cnscl([wm,vm]);
            phim = clbt.Kg*phim-clbt.eb*nts; dvbm = clbt.Ka*dvbm-clbt.db*nts;
            wb = phim/nts; fb = dvbm/nts;
            SS = lvS(Cba, wb, dwb);  fL = SS*[clbt.rx;clbt.ry;clbt.rz];  % lever arm
            fn = qmulv(qnb, fb-clbt.Ka2.*fb.^2-fL-clbt.tGA*cross(wb,fb));
            an = rotv(-wnie*nts/2, fn) + gn;
            vn = vn + an*nts;
            qnb = qupdt2(qnb, phim, wnie*nts);   % insupdate
            t1s = t1s + nts;
            kf.Phikk_1 = eye(kf.n)+getFt(fb, wb, q2mat(qnb), wnie, SS)*nts;
            kf = kfupdate(kf);
            if t1s>(1-ts/2)  % kf measurement update every 1 second
                t1s = 0;
                ww = mean(imu(k-frq2:k+frq2,1:3),1); ww = norm(ww)/ts;
                if ww<20*glv.dph   % if IMU is static
                    kf = kfupdate(kf, vn);
                    vn1s(kkv,:) = [vn; t]';  kkv = kkv+1;
                end
                av(kk,:) = [q2att(qnb); vn; t]';
                xkpk(kk,:) = [kf.xk; diag(kf.Pxk); t]'; kk = kk+1;
            end
            timebar;
        end
        if iter~=itertion,  clbt = clbtkffeedback(kf, clbt);  end
        vn1s(kkv:end,:) = []; av(kk:end,:) = []; xkpk(kk:end,:) = [];
        clbtkfplot(av, xkpk, vn1s, imu, dotwf, iter);
    end
    clbtkfplot(av, xkpk, vn1s, imu, dotwf, 100);
    
function kf = clbtkfinit(ts)
global glv
    kf.Qt = diag([ [1;1;1]*0.01*glv.dpsh; [1;1;1]*100*glv.ugpsHz; zeros(37,1) ])^2;
    kf.Rk = diag([1;1;1]*0.01)^2;
    kf.Pxk = diag([ [0.1;0.1;1]*glv.deg; [1;1;1]; [1;1;1]*0.1*glv.dph; [1;1;1]*glv.mg; ...
        [100*glv.ppm;100*glv.sec;100*glv.sec]; [100*glv.sec;100*glv.ppm;100*glv.sec]; [100*glv.sec;100*glv.sec;100*glv.ppm]; ...
        [100*glv.ppm;100*glv.sec;100*glv.sec]; [  0*glv.sec;100*glv.ppm;100*glv.sec]; [  0*glv.sec;  0*glv.sec;100*glv.ppm]; [1;1;1]*100*glv.ugpg2; ...
        [1;1;1]*0.1; [1;1;1]*0.1; [1;1;1]*0.0; 0.01 ])^2;
    kf.Hk = [zeros(3),eye(3),zeros(3,37)];
    kf = kfinit0(kf, ts);
    
function clbt = clbtkffeedback(kf, clbt)   % kffeedback
    clbt.Kg = (eye(3)-reshape(kf.xk(13:21),3,3))*clbt.Kg;
    clbt.Ka = (eye(3)-reshape(kf.xk(22:30),3,3))*clbt.Ka; clbt.Ka2 = clbt.Ka2+kf.xk(31:33);
    clbt.eb = clbt.eb+kf.xk(7:9); clbt.db = clbt.db+kf.xk(10:12);
    clbt.rx = clbt.rx+kf.xk(34:36); clbt.ry = clbt.ry+kf.xk(37:39); clbt.rz = clbt.rz+kf.xk(40:42);
    clbt.tGA = clbt.tGA+kf.xk(43);

function Ft = getFt(fb, wb, Cnb, wnie, SS)   % kffk
    o33 = zeros(3); o31 = zeros(3,1);
    wX = askew(wnie); fX = askew(Cnb*fb);
    wx = wb(1); wy = wb(2); wz = wb(3); fx = fb(1); fy = fb(2); fz = fb(3);
    CDf2 = Cnb*diag(fb.^2); CwXf = Cnb*cross(wb,fb);
    %states: fi  dvn   eb   db    dKg(:,1) dKg(:,2) dKg(:,3) dKa(:,1) dKa(:,2) dKa(:,3) dKa2  rx  ry  rz   tGA
    Ft = [  -wX  o33  -Cnb  o33  -wx*Cnb  -wy*Cnb  -wz*Cnb   o33      o33      o33      o33   o33 o33 o33  o31
             fX  o33   o33  Cnb   o33      o33      o33      fx*Cnb   fy*Cnb   fz*Cnb   CDf2  Cnb*SS       CwXf
             zeros(37,43) ];

function SS = lvS(Cba, wb, dotwb)
    U = (Cba')^-1; V1 = Cba(:,1)'; V2 = Cba(:,2)'; V3 = Cba(:,3)';
    Q11 = U(1,1)*V1; Q12 = U(1,2)*V2; Q13 = U(1,3)*V3;
    Q21 = U(2,1)*V1; Q22 = U(2,2)*V2; Q23 = U(2,3)*V3;
    Q31 = U(3,1)*V1; Q32 = U(3,2)*V2; Q33 = U(3,3)*V3;
    W = askew(dotwb)+askew(wb)^2;
    SS = [Q11*W, Q12*W, Q13*W; Q21*W, Q22*W, Q23*W; Q31*W, Q32*W, Q33*W];
    
function clbtkfplot(av, xkpk, vn1s, imu, dotwf, iter)
global glv
    if iter==1
        myfigure
        subplot(221), plot(av(:,end), av(:,1:3)/glv.deg); xygo('att');
        subplot(223), plot(av(:,end), av(:,4:6), vn1s(:,end),vn1s(:,1:3),'*'); xygo('V');
        subplot(2,2,[2,4]), plot(dotwf(:,end), dotwf(:,1:3)/glv.deg, ':'), xygo('\omega / \circ/s, d\omega/dt / \circ/s^2');
            hold on, plot(imu(:,end), imu(:,1:3)/diff(imu(1:2,end))/glv.dps, vn1s(:,end),vn1s(:,3)*0,'*');
    end
    if iter==100
        plotxk([sqrt(xkpk(:,[44:end-1])),xkpk(:,end)]);
    else
        plotxk(xkpk(:,[1:43,end]));  subplot(332), plot(av(:,end), av(:,4:6), 'm');
    end
 
function plotxk(xk)        
global glv
    myfigure
    t = xk(:,end);
    subplot(331), plot(t, xk(:,1:3)/glv.min); xygo('phi');
    subplot(332), plot(t, xk(:,4:6)); xygo('dvn')
    subplot(333), plot(t, xk(:,7:9)/glv.dph); xygo('eb');
    subplot(334), plot(t, xk(:,10:12)/glv.ug); xygo('db');
    subplot(335), plot(t, xk(:,13:4:21)/glv.ppm); xygo('dKii / ppm');
        hold on,  plot(t, xk(:,22:4:30)/glv.ppm, '--');
    subplot(336), plot(t, xk(:,[14:16,18:20])/glv.sec); xygo('dKij / \prime\prime');
    	hold on,  plot(t, xk(:,[23:25,27:29])/glv.sec, '--');
    subplot(337), plot(t, xk(:,31:33)/glv.ugpg2); xygo('Ka2 / ug/g^2');
    subplot(338), plot(t, xk(:,34:36)); xygo('lever arm / m');
    	hold on,  plot(t, xk(:,37:39),'--'); plot(t, xk(:,40:42), '-.');
    subplot(339), plot(t, xk(:,43)); xygo('\tau_{GA} / s');
