function att = Mahony1(imu, att0)
% See also  MahonyInit, MahonyUpdate, inspure.
    if ~exist('att0', 'var'), att0 = zeros(3,1); end
    ts = diff(imu(1:2,end));
    ahrs = MahonyInit(0, att0);
    att = imu(:,4:end);
    ki = timebar(1, length(imu)/2, 'Mahony processing.');
    for k=1:2:length(imu)-1
        if k>60*10, 
            a = 1;
        end
        ahrs = MahonyUpdate(ahrs, imu(k:k+1,1:6), 0, ts);
        att(ki,:) = [m2att(ahrs.Cnb);imu(k+1,end)];
        ki = timebar;
    end
    att(ki:end,:) = [];
    insplot(att);
    