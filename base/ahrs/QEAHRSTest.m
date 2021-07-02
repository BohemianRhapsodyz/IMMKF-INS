function avp = QEAHRSTest(imu, mag, att0)
global glv
    if ~exist('mag', 'var'), mag = []; end
    if isempty(mag), mag=imu(:,1:3)*0; end
    if ~exist('att0', 'var'), att0 = zeros(3,1); end
    ts = diff(imu(1:2,end));
    ahrs = QEAHRSInit(ts, att0);
    len=length(imu);
    avp = zeros(len, 17);
    timebar(1,len,'Quaternion EKF based AHRS test.');
    for k=1:len
        ahrs = QEAHRSUpdate(ahrs, imu(k,:), mag(k,:)', ts);
        avp(k,:) = [m2att(ahrs.Cnb); ahrs.kf.xk(5:7); diag(ahrs.kf.Pxk); diag(ahrs.kf.Rk); ahrs.tk];
        timebar;
    end
    myfigure
    subplot(321), plot(avp(:,end),avp(:,1:3)/glv.deg); xygo('att'); 
    subplot(322), plot(avp(:,end),avp(:,4:6)/glv.dph); xygo('eb');
    subplot(323), plot(avp(:,end),sqrt(avp(:,7:10))); xygo('\deltaq');
    subplot(324), plot(avp(:,end),sqrt(avp(:,11:13))/glv.dph); xygo('eb');
    subplot(325), plot(avp(:,end),sqrt(avp(:,14:15))/glv.mg); xygo('R_{fx,y} / mg');
    subplot(326), plot(avp(:,end),sqrt(avp(:,16))); xygo('R_{mag}');

