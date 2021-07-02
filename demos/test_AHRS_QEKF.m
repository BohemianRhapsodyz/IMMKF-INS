glvs
ts = 0.1;
ahrs = QEAHRSInit(ts);
len = 100/ts; avp = zeros(len, 14);
for k=1:len
    ahrs = QEAHRSUpdate(ahrs, [[1,0,0]*0, [1,0,1/glv.deg]], [0;0;0], ts);
    avp(k,:) = [m2att(ahrs.Cnb); ahrs.kf.xk(5:7); diag(ahrs.kf.Pxk); ahrs.tk];
end
figure,
subplot(231), plot(avp(:,end), avp(:,1:2)/glv.deg), xygo('pr')
subplot(232), plot(avp(:,end), avp(:,3)/glv.deg), xygo('y')
subplot(233), plot(avp(:,end), avp(:,4:6)/glv.dph), xygo('eb')
subplot(234), plot(avp(:,end), sqrt(avp(:,7:10))), xygo('q')
subplot(235), plot(avp(:,end), sqrt(avp(:,11:13))/glv.dph), xygo('eb')

