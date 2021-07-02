% SINS linear-error-model propagation accuracy verification.
% Please run 'test_SINS_trj.m' to generate 'trj10ms.mat' beforehand!!!
% See also  test_SINS_trj, test_SINS, test_SINS_GPS.
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 25/05/2014
glvs
trj = trjfile('trj10ms.mat');
% initial settings
psinstypedef(346);
[nn, ts, nts] = nnts(2, trj.ts);
imuerr = imuerrset(0.01, 100, 0, 0, 0,0,0,0, 10, 10);
imu = imuadderr(trj.imu, imuerr);
davp0 = avpseterr([10;-10;30], 0.1, [10;10;30]);
ins = insinit(avpadderr(trj.avp0,davp0), ts);
xk = [davp0; imuerr.eb; imuerr.db; zeros(4,1); imuerr.dKga];  % init state error
len = length(imu)/4; [avp, xkk, zkk] = prealloc(fix(len/nn), 10, 10, 7);
ki = 1;
tbstep = floor(len/nn/100); tbi = timebar(1, 99, 'SINS linear error model verifies.');
for k=1:nn:len-nn+1
    k1 = k+nn-1;  
    wvm = imu(k:k1,1:6);  t = imu(k1,end);
    ins = insupdate(ins, wvm);    ins = inslever(ins);
    Fk = kffk(ins); Hk = kfhk(ins); Hk(1:3,1:3) = -askew(ins.vn); % ??
    xk = Fk*xk; zk = Hk*xk;
    avp(ki,:) = [ins.avp', t];
    xkk(ki,:) = [xk(1:9)', t];
    zkk(ki,:) = [zk', t]; ki = ki+1;
    if mod(tbi,tbstep)==0, timebar; end;  tbi = tbi+1;
end
avperr = avpcmp(avp, trj.avp);
insplot(avp);
inserrplot(avperr);
subplot(221), hold on, plot(xkk(:,end), xkk(:,1:2)/glv.sec, 'm:');
subplot(222), hold on, plot(xkk(:,end), xkk(:,3)/glv.min, 'm:');
subplot(223), hold on, plot(xkk(:,end), [xkk(:,4:6)], 'm:');
subplot(223), hold on, plot(xkk(:,end), [zkk(:,1:3)], 'b:');
subplot(224), hold on, plot(xkk(:,end), [xkk(:,7:8)*glv.Re,xkk(:,9)], 'm:');
inserrplot(avpcmp(xkk, avperr));
