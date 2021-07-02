% SINS algorithm accuracy verification with analytical east-west trajectory. 
% See also  test_SINS, test_SINS_static.
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 19/05/2014
glvs
[nn, ts, nts] = nnts(2, .1);
% avp0 = avpset([0;0;0], [660;0;0], [30;108;0]);
% trj = trjEast(avp0, 1, 100, 0.01, ts, 3600); % analytical east-west trajectory
avp0 = avpset([0;0;0], [0;1000;0], [30;108;0]);
glvf([],0); trj = trjNorth(avp0, ts, 3600); % analytical east-west trajectory
% imuplot(trj.imu); insplot(trj.avp);
ins = insinit(avp0, ts);  ins.an = qmulv(ins.qnb,trj.imu(1,4:6)'/ts) + ins.eth.gcc;
len = length(trj.imu); avp = zeros(len/nn,10);
tbstep = floor(len/nn/100); ki = timebar(1, 99);
for k=1:nn:len-nn
    wvm = trj.imu(k:k+nn-1,1:6); t = trj.imu(k+nn-1,7);
    ins = insupdate(ins, wvm);  ins.vn(3) = 0; ins.pos(3) = 0;
    avp(ki,:) = [ins.avp; t]';
    if mod(ki,tbstep)==0, timebar; end;  ki = ki+1;
end
avperr = avpcmp(avp, trj.avp);
inserrplot(avperr);

