function imu = imuadderr(imu, imuerr, ts)
% SIMU outputs adding errors simulation, denoted as:
%    imu = K*imu + drift error.
%
% Prototype: imu = imuadderr(imu, imuerr, ts)
% Inputs: imu - raw SIMU data
%         imuerr - SIMU error struture array
% Output: imu - output SIMU data added errors
%
% See also  imuerrset, imudeldrift, avpseterr, trjsimu, insupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 11/09/2013, 06/03/2014, 21/07/2015, 17/08/2016, 24/02/2017
    if nargin<3,  ts = imu(2,7)-imu(1,7);  end  % the last column implies sampling interval
    [m, n] = size(imu); sts = sqrt(ts);
    drift = [ ts*imuerr.eb(1) + sts*imuerr.web(1)*randn(m,1), ...
              ts*imuerr.eb(2) + sts*imuerr.web(2)*randn(m,1), ...
              ts*imuerr.eb(3) + sts*imuerr.web(3)*randn(m,1), ...
              ts*imuerr.db(1) + sts*imuerr.wdb(1)*randn(m,1), ...
              ts*imuerr.db(2) + sts*imuerr.wdb(2)*randn(m,1), ...
              ts*imuerr.db(3) + sts*imuerr.wdb(3)*randn(m,1) ];
    if min(abs(imuerr.sqg))>0
        mvg = markov1(imuerr.sqg.*sqrt(imuerr.taug/2), imuerr.taug, ts, m);   % q = 2*sigma.^2.*beta
        drift(:,1:3) = drift(:,1:3) + mvg*ts;
    end
    if min(abs(imuerr.sqa))>0
        mva = markov1(imuerr.sqa.*sqrt(imuerr.taua/2), imuerr.taua, ts, m);
        drift(:,4:6) = drift(:,4:6) + mva*ts;
    end
    if min(abs(imuerr.KA2))>0
        imu(:,4:6) = [ imu(:,4)+imuerr.KA2(1)/ts*imu(:,4).^2, ...
                       imu(:,5)+imuerr.KA2(2)/ts*imu(:,5).^2, ...
                       imu(:,6)+imuerr.KA2(3)/ts*imu(:,6).^2 ];
    end
    if isfield(imuerr, 'dKg')
        Kg = eye(3)+imuerr.dKg; Ka = eye(3)+imuerr.dKa;
        imu(:,1:6) = [imu(:,1:3)*Kg', imu(:,4:6)*Ka'];
    end
    imu(:,1:6) = imu(:,1:6) + drift;
