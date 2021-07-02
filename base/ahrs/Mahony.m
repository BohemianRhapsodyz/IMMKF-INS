function att = Mahony(imu, att0)
% See also  MahonyInit, MahonyUpdate, inspure.
    if ~exist('att0', 'var'), att0 = zeros(3,1); end
    ts = diff(imu(1:2,end));
    ahrs = MahonyInit(0, att0);
    att = imu(:,4:end);
    ki = timebar(1, length(imu)/2, 'Mahony processing.');
    for k=1:2:length(imu)-1
        [phim, dvbm] = cnscl(imu(k:k+1,1:6));
        ahrs = MahonyUpdate(ahrs, [phim;dvbm]', 0, 2*ts);
        att(ki,:) = [m2att(ahrs.Cnb);imu(k+1,end)];
        ki = timebar;
    end
    att(ki:end,:) = [];
    insplot(att);
    