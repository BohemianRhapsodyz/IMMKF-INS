glvs
ts = 0.1;
ahrs = MahonyInit(4);
len = 50/ts; avp = zeros(len, 7);
for k=1:len
    ahrs = MahonyUpdate(ahrs, [[1,0,0]*0, [1,0,1/glv.deg]], [0.2;-10;0], ts);
    avp(k,:) = [m2att(ahrs.Cnb); ahrs.exyzInt; ahrs.tk];
end
sysw=tf([1,0], [1,ahrs.Kp,ahrs.Ki]);
yw = step(sysw,avp(:,end));
sysf=tf([ahrs.Kp,ahrs.Ki], [1,ahrs.Kp,ahrs.Ki]);
yf = step(sysf,avp(:,end));
figure,
subplot(221), plot(avp(:,end), [avp(:,1)/glv.deg, yw]), xygo('p')
subplot(222), plot(avp(:,end), [avp(:,2)/glv.deg,-yf]), xygo('r')
subplot(223), plot(avp(:,end), [avp(:,3)/glv.deg]), xygo('y')
subplot(224), plot(avp(:,end), avp(:,4:6)/glv.dph), xygo('eb')
[ahrs.Kp, ahrs.Ki]
mahplot(avp);