% Slave IMU simulation for tranfer align.
% Please run 'test_align_transfer_trj.m' beforehand!!!
% See also  test_align_transfer_trj, test_align_transfer.
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 02/06/2011
glvs
load([glv.datapath,'trj_transfer.mat']);
ts = trj.ts;
%% flexure-deformation angles using 2nd Markov
sigma = [6;-10;7]*glv.min; tau = [.5;.4;10];  % 2nd order Markov parameters
len = length(trj.avp);
[thetak, omegak, beta, Q] = markov2(sigma, tau, ts, len);
t = (1:length(thetak))'*ts;
myfigure
subplot(211),plot(t, thetak/glv.min), xygo('theta'); title('Flexure Angles')
subplot(212),plot(t, omegak/glv.dps), xygo('w'); title('Flexure Angular Rates')
%% slave IMU simulation
mub = [.3; .4; -.2]*glv.deg; % mounting misalignments
qbba = rv2q(mub); qbabs = rv2q(thetak(1,:)'); qbbs = qmul(qbba,qbabs);  
qnbs0 = qmul(a2qua(trj.avp0(1:3)'),qbbs);
[imu, qnbsk] = prealloc(len, 7, 4);
for k=1:len
    qbabs = rv2q(thetak(k,:)');
    qbbs = qmul(qbba,qbabs);
    qnbsk(k,:) = qmul(a2qua(trj.avp(k,1:3)'),qbbs)';
    wm = qmulv(qconj(qbbs),trj.imu(k,1:3)')'+omegak(k,:)*ts;
    vm = qmulv(qconj(qbbs),trj.imu(k,4:6)')';
    imu(k,:) = [wm, vm, trj.imu(k,7)];
end
imuerr = imuerrset(0.1, 1000, 0.01, 100);
imu = imuadderr(imu, imuerr);
imuplot(imu);
save([glv.datapath,'imu_transfer.mat'], ...
    'imu', 'imuerr', 'Q', 'beta', 'thetak', 'omegak', 'mub', 'qnbs0', 'qnbsk');

