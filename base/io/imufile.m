function [imu, avp0, ts] = imufile(fname, imu, avp0, ts, scales, infostr)
% Create or read PSINS compact text-format SIMU file. The text file has
% high compress ratio when compress tools are applied.
%
% Prototype: [imu, avp0, ts] = imufile(fname, imu, avp0, ts, scales, infostr)
% Inputs: fname - text file name, with default extension '.imu'
%         imu - SIMU incremental sampling data (gyro in rad, acc in m/s)
%         avp0 - SIMU initial avp0=[att; vn; pos, t0]
%               NOTE: t0+ts = sampling time of the first IMU record
%         ts - sampling interval (in time second)
%         scales - scale factors for each SIMU column(gyro in sec, acc in ug*s)
%         infostr - user's infomation string
% Outputs: imu - see above
%          avp0 - see above
%          ts - see above
% Usages: 
%    Create: imufile(fname, imu, avp0, ts, scales, infostr)
%    Read:   [imu, avp0, ts] = imufile(fname)
%
% See also  avpfile, binfile, trjfile, imuresample, imuplot.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 10/08/2011, 09/10/2013, 12/03/2014
global glv
    fname = fnamechk(fname, 'imu');
    if nargin>1 % create file
        if nargin<6,  infostr='by Gongmin Yan';  end
        if nargin<5,  scales=1;  end
        if nargin<4,  ts=mean(diff(imu(:,7)));  end
        scales = scales(:)';
        if length(scales)<2,  scales=[0.1, 125];  end
        if length(scales)==2,  scales=[repmat(scales(1),1,3), repmat(scales(2),1,3)];  end
        scales0 = scales;
        scales = [scales(1:3)*glv.sec, scales(4:6)*glv.ug];
        avp0 = avp0(:)';
        if length(avp0)==3 % [pos]
            avp0 = [zeros(1,6), avp0, 0];
        elseif length(avp0)==6 % [att,pos]
            avp0 = [avp0(1:3),zeros(1,3),avp0(4:6),0];
        elseif length(avp0)==9 % [att,vn,pos]
            avp0 = [avp0,0];
        end
        if avp0(end)<0,  avp0(end) = imu(1,7)-ts;  end
        t = imu(:,7)-imu(1,7)+ts+avp0(end);
        t = t - (1:length(t))'*ts;
        t = [0;diff(fix(t*1e6))]; % milli second
        imu = imu(:,1:6);
        for k=1:6,  imu(:,k) = imu(:,k)/scales(k);  end
        imu = diff([zeros(1,6); fix(cumsum(imu,1))]);
        fid = fopen(fname, 'wt');
        print_header(fid, infostr);
        if sum(abs(t))>0
            fprintf(fid, '%f %f %f %f %f %f 0\n', r2d(avp0(1)), r2d(avp0(2)), r2d(avp0(3)), avp0(4), avp0(5), avp0(6));
            fprintf(fid, '%.8f %.8f %.3f %.8f %.8f %f 0\n', r2d(avp0(7)), r2d(avp0(8)), avp0(9), avp0(end), ts*1000, glv.g0);
            fprintf(fid, '%f %f %f %.3f %.3f %.3f 0\n\n', scales0);
            fprintf(fid, '%d %d %d %d %d %d %d\n', [imu,t]');
        else
            fprintf(fid, '%f %f %f %f %f %f\n', r2d(avp0(1)), r2d(avp0(2)), r2d(avp0(3)), avp0(4), avp0(5), avp0(6));
            fprintf(fid, '%.8f %.8f %.3f %.8f %.8f %f\n', r2d(avp0(7)), r2d(avp0(8)), avp0(9), avp0(end), ts*1000, glv.g0);
            fprintf(fid, '%f %f %f %.3f %.3f %.3f\n\n', scales0);
            fprintf(fid, '%d %d %d %d %d %d\n', imu');
        end
        fclose(fid);
    else % read file
        fid = fopen(fname, 'rt');
        str = fgetl(fid);
        fclose(fid);
        if isempty(strfind(str,'PSINS')) || isempty(strfind(str,'SIMU'))
            error('PSINS-format SIMU log file error!');
        end
        imu = load(fname);
        avp0(1:6,1) = [d2r(imu(1,1:3)), imu(1,4:6)]';
        avp0(7:10,1) = [d2r(imu(2,1:2)),imu(2,3:4)]'; ts = imu(2,5)/1000; g = imu(2,6);
        scales = [imu(3,1:3)*glv.sec, imu(3,4:6)*(1e-6*g)];
        imu(1:3,:) = [];
        for k=1:6,  imu(:,k) = imu(:,k)*scales(k);  end
        if size(imu,2)==7
            imu(:,7) = avp0(10) + (1:length(imu))'*ts + cumsum(imu(:,7))*1e-6;
        else
            imu(:,7) = avp0(10) + (1:length(imu))'*ts;
        end
    end

function print_header(fid, infostr)
	fprintf(fid, '%% PSINS-format SIMU log file. (DO NOT MODIFY!)\n');
	fprintf(fid, '%% %s  %s\n', datestr(now,31), infostr);
	fprintf(fid, '%% 1st line of the data header includes(maybe inaccurate):\n');
	fprintf(fid, '%%   [pitch0(deg), roll0(deg), yaw0(deg), VE0(m/s), VN0(m/s), VU0(m/s)].\n');
	fprintf(fid, '%% 2nd line of the data includes:\n');
	fprintf(fid, '%%   [latitude0(deg), longitude0(deg), height0(m), t0(s), sampling-interval(ms), g(m/s^2)].\n');
	fprintf(fid, '%% 3rd line of the data header includes:\n');
	fprintf(fid, '%%   [gf_x, gf_y, gf_z, af_x, af_y, af_z]\n');
	fprintf(fid, '%%   where gf_* is gyro scale factor in arcsec, af_* is acc scale factor in ug*s.\n');
	fprintf(fid, '%% SIMU data columns include:\n');
	fprintf(fid, '%%   [g_x, g_y, g_z, a_x, a_y, a_z, dt]\n');
	fprintf(fid, '%%   where dt, if exists, is sampling time dither in millisecond.\n');    
	fprintf(fid, '%%   Conventionally, SIMU is mounted on vehicle with "x-Right,y-Forward,z-Up" orientations.\n\n');
