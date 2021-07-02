function trj = trjsimu(avp0, wat, ts, repeats)
% Trajectory simulator (Ref. See my master's dissertation p63).
%
% Prototype: trj = trjsimu(avp0, wat, ts, repeats)
% Inputs: avp0 - initial attitude, velocity and position
%         wat - segment parameter, each column described as follows:
%            wat(:,1) - period lasting time
%            wat(:,2) - period initial velocity magnitude
%            wat(:,3:5) - angular rate in trajectory-frame
%            wat(:,6:8) - acceleration in trajectory-frame
%         ts - simulation time step
%         repeats - trajectory repeats using the same 'wat' parameter. 
% Output: trj - trajectory structrue array, including fields:
%            imu - gyro angular increments, acc velocity increments 
%              & time tag, i.e. imu = [wm,vm,t]
%            avp - trajectory attitude, velocity, position & time tag
%            avp0, wat, ts repeats - the same as inputs
%
% See also  trjsegment, imustatic, odsimu, gpssimu, conesimu, scullsimu,
%           imuadderr, insupdate, cnscl, imuplot, imufile.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 01/10/2012, 19/03/2014(simular to avp2imu)
global glv
    if nargin<4, repeats = 1; end
    wat1 = repmat(wat, repeats, 1);
    damping = 1-exp(-ts/5.0);
    att = avp0(1:3); vn = avp0(4:6); pos = avp0(7:9);
    eth = earth(pos, vn);  Cbn_1 = a2mat(att)';  wm_1 = [0;0;0]; ts2 = ts/2;
%     Mpv = [0, 1/eth.RMh, 0; 1/eth.clRNh, 0, 0; 0, 0, 1];
    len = fix(sum(wat1(:,1))/ts);
    [imu, avp] = prealloc(len, 7, 10);
    ki = timebar(1, len, 'Trajectory Simulation.');
    for k=1:size(wat1,1)
        lenk = round(wat1(k,1)/ts);  % the lenght at k phase
        wt = wat1(k,3:5)'; at = wat1(k,6:8)';
        ufflag = 0;
        if norm(wt)==0 && norm(at)==0  % uniform phase flag
            ufflag = 1; 
            vnr = a2mat(att)*[0;wat1(k,2);0];  % velocity damping reference
        end
        for j=1:lenk
            sa = sin(att); ca = cos(att);
            si = sa(1); sk = sa(3); ci = ca(1); ck = ca(3); 
            Cnt = [ ck, -ci*sk,  si*sk; 
                    sk,  ci*ck, -si*ck; 
                    0,   si,     ci ];
            att = att + wt*ts;
            Cnb = a2mat(att);   % attitude
            if ufflag==1  % damping
                na = norm(vn-vnr)/ts;  maxa = 0.1;
                if na<maxa,  na=maxa;  end  % max an is limited to maxa/(m/s^2)
                vn1 = vn-damping/na*(vn-vnr);  an = (vn1-vn)/ts;
                vn01 = (vn+vn1)/2;  vn = vn1;
            else
                an = Cnt*at;
                vn1 = vn + an*ts;  vn01 = (vn+vn1)/2;  vn = vn1;  % velocity
            end
            dpos01 = [vn01(2)/eth.RMh;vn01(1)/eth.clRNh;vn01(3)]*ts2;
            eth = earth(pos+dpos01, vn01);
            pos = pos+dpos01*2;      % position
%             eth = earth(pos+Mpv*vn01*ts2, vn01);
%             Mpv = [0, 1/eth.RMh, 0; 1/eth.clRNh, 0, 0; 0, 0, 1];
%             pos = pos+Mpv*vn01*ts;      % position
            phim = m2rv(Cbn_1*Cnb) + (Cbn_1+Cnb')*(eth.wnin*ts2);
%             wm = phim;
            wm = (glv.I33+askew(wm_1/12))^-1*phim;   % gyro increment
%             wm = (glv.I33-askew(wm_1/12))*phim;   % gyro increment
%             dvbm = Cbn_1*qmulv(rv2q(eth.wnin*ts2), (an-eth.gcc)*ts);
            dvbm = Cbn_1*(rv2m(eth.wnin*ts2)*(an-eth.gcc)*ts);
            vm = (glv.I33+askew(wm/2))^-1*dvbm;   % acc increment
%             vm = (glv.I33-askew(wm/2))*dvbm;   % acc increment
            kts = ki*ts;
            avp(ki,:) = [att; vn; pos; kts]';
            imu(ki,:) = [wm; vm; kts]';
            wm_1 = wm; Cbn_1 = Cnb';
            ki = timebar;
        end
    end
    trj = varpack(imu, avp, avp0, wat, ts, repeats);

