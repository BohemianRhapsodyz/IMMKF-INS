function wm = att2wm(att, pos)
% In static base, transfer attitude to gyro increment outputs.
%
% Prototype: wm = att2wm(att, pos)
% Inputs: att - attitude input serials
%         pos - position [lat, *, *]
% Output: wm - gyro increment outputs
%
% See also  trjsimu.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 23/09/2014(simular to avp2imu)
    if length(pos)==1, pos = [pos;0;0]; end  % if pos==latitude
    wm = att(2:end,:);
    I33 = eye(3); wm_1 = zeros(3,1);
    ts = diff(att(1:2,4));
    eth = earth(pos); wnints2 = eth.wnin*ts/2;
    Cbn_1 = a2mat(att(1,1:3)')';
    for k = 2:length(att)
        Cnb = a2mat(att(k,1:3)'); Cbn = Cnb';
        phim = m2rv(Cbn_1*Cnb) + (Cbn_1+Cbn)*wnints2;
        Cbn_1 = Cbn;
        wm(k-1,:) = [(I33+askew(wm_1/12))^-1*phim; att(k,4)]';
    end