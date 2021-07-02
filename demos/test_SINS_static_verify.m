% Copyright(c) 2009-2015, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 27/11/2015
glvs
T = 60;  % total simulation time length
[nn, ts, nts] = nnts(1, 0.1);
avp0 = avpset([0;0;0], [0;0;0], [34;110;380]);  eth = earth(avp0(7:9));
imuerr = imuerrset([0;0;0.], [0;0;0], 0.0, 0.0);
imu = imustatic(avp0, ts, T, imuerr);   % SIMU simulation
davp0 = avpseterr([0;0;0], [0.0;10.0;0.0], [0;0;0]);
avp00 = avpadderr(avp0, davp0);
ins = insinit(avp00, ts);
len = length(imu);    avp = zeros(fix(len/nn), 10);
ki = timebar(nn, len, 'Pure inertial navigation processing.');
for k=1:nn:len-nn+1
	k1 = k+nn-1;
	wvm = imu(k:k1, 1:6);  t = imu(k1,7);
	ins = insupdate(ins, wvm);  ins.vn(3) = 0;  ins.pos(3) = avp0(9);
	avp(ki,:) = [ins.avp; t]';
	ki = timebar;
end
avperr = avpcmp(avp, avp0);
inserrplot(avperr);
%% 前面是惯导解算误差，后面是理论误差
R = sqrt(eth.RNh*eth.RMh); L = avp0(7); tL = tan(L); eL = sec(L);
wN = eth.wnie(2); wU = eth.wnie(3); g = -eth.gn(3);
qnb = a2qua(avp0(1:3)); en = qmulv(qnb,imuerr.eb); dn = qmulv(qnb,imuerr.db);
X0 = [davp0([1:5,7:8])]; U = [-en; dn(1:2); 0; 0];
F = [ 0   wU -wN  0    -1/R   0   0
     -wU  0   0   1/R   0    -wU  0  
      wN  0   0   tL/R  0     wN  0  
      0  -g   0   0     2*wU  0   0  
      g   0   0  -2*wU  0     0   0  
      0   0   0   0     1/R   0   0  
      0   0   0   eL/R  0     0   0 ];
[Fk, Bk] = c2d(F, eye(size(F)), ts); Uk = Bk*U;  % 离散化
Xk = X0; XX = zeros(len,8);
for k=1:len
    Xk = Fk*Xk+Uk;
    XX(k,:) = [Xk; k*ts]';
end
subplot(221), plot(XX(:,end), XX(:,1:2)/glv.sec, 'm');
subplot(222), plot(XX(:,end), XX(:,3)/glv.min, 'm');
subplot(223), plot(XX(:,end), XX(:,4:5), 'm');
subplot(224), plot(XX(:,end), XX(:,6:7)*glv.Re, 'm');