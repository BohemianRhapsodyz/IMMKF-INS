function ss = olsins(ss, imu, ts)
% 开环sins导航——速度不影响姿态；位置不更新 / open loop SINS
% 参考博士论文P41。
% 初始化调用格式 ss = olsins(qnb0, pos0, ts)
    if isstruct(ss)==0
        qnb0 = ss; pos0 = imu;
        ss = [];
        [ss.qnb, ss.att, ss.Cnb] = attsyn(qnb0); ss.vn  = [0;0;0]; ss.pos  = pos0;
        ss.eth = earth(ss.pos);
        ss.wb = ss.Cnb'*ss.eth.wnie; ss.fb = -ss.Cnb'*ss.eth.gn;
        ss.ts = ts;
        return;
    end
    nts = ss.ts*size(imu,1);
    [phim,dvbm] = cnscl(imu); 
    ss.Cnb = q2cnb(ss.qnb);
    ss.wb = phim/nts-ss.Cnb'*ss.eth.wnin; ss.fb = dvbm/nts;
    ss.vn = ss.vn + qmulv(rv2q(-ss.eth.wnie*(nts/2)),ss.Cnb*dvbm) + ss.eth.gn*nts;
    ss.qnb = qmul(ss.qnb, rv2q(ss.wb*nts));
    [ss.qnb, ss.att, ss.Cnb] = attsyn(ss.qnb);
