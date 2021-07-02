function avp = avpfile(fname, avp, infostr)
% Create or read PSINS text-format AVP/GPS file.
%
% Prototype: avp = avpfile(fname, avp, infostr)
% Inputs: fname - file name, with default extension '.avp'
%         avp - AVP/GPS position, velocity (or even attitude), 
%               accuracy factor and time tag
%         infostr - user's infomation string to be written to the file
% Output: avp - avp read from the file
% Usages: 
%    Create: avpfile(fname, avp, infostr)
%    Read:   avp = avpfile(fname)
%
% See also  imufile, binfile, trjfile, pos2gpx, gpsplot.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 12/03/2014
    fname = fnamechk(fname, 'avp');
    if nargin>1 % create file
        if nargin<3,  infostr='by Gongmin Yan';  end
        fid = fopen(fname, 'wt');
        fprintf(fid, '%% PSINS-format AVP/GPS log file. (DO NOT MODIFY!)\n');
        fprintf(fid, '%% %s  %s\n', datestr(now,31), infostr);
        n = size(avp,2);
        if n==4 % [pos,time]
            avp(:,1:2) = r2d(avp(:,1:2));
            str0 = 'lat(deg),lon(deg),height(m),time(s)';
            str = '%.8f %.8f %.3f %g\n';
        elseif n==5 % [pos,tag,time]
            avp(:,1:2) = r2d(avp(:,1:2));
            str0 = 'lat(deg),lon(deg),height(m),tag,time(s)';
            str = '%.8f %.8f %.3f %g %g\n';
        elseif n==7 % [vn,pos,time]
            avp(:,4:5) = r2d(avp(:,4:5));
            str0 = 'VE(m/s),VN(m/s),VU(m/s),lat(deg),lon(deg),height(m),time(s)';
            str = '%.3f %.3f %.3f %.8f %.8f %.3f %g\n';
        elseif n==8 % [vn,pos,tag,time]
            avp(:,4:5) = r2d(avp(:,4:5));
            str0 = 'VE(m/s),VN(m/s),VU(m/s),lat(deg),lon(deg),height(m),tag,time(s)';
            str = '%.3f %.3f %.3f %.8f %.8f %.3f %g %g\n';
        elseif n==10 % [att,vn,pos,time]
            avp(:,[1:3,7:8]) = r2d(avp(:,[1:3,7:8]));
            str0 = 'pitch(deg),roll(deg),yaw(deg),VE(m/s),VN(m/s),VU(m/s),lat(deg),lon(deg),height(m),time(s)';
            str = '%.4f %.4f %.4f %.3f %.3f %.3f %.8f %.8f %.3f %g\n';
        elseif n==11 % [att,vn,pos,tag,time]
            avp(:,[1:3,7:8]) = r2d(avp(:,[1:3,7:8]));
            str0 = 'pitch(deg),roll(deg),yaw(deg),VE(m/s),VN(m/s),VU(m/s),lat(deg),lon(deg),height(m),tag,time(s)';
            str = '%.4f %.4f %.4f %.3f %.3f %.3f %.8f %.8f %.3f %g %g\n';
        end
        fprintf(fid, '%% %s\n\n', str0);
        fprintf(fid, str, avp');
        fclose(fid);
    else % read file
        fid = fopen(fname, 'rt');
        str = fgetl(fid);
        fclose(fid);
        if isempty(strfind(str,'PSINS')) || isempty(strfind(str,'AVP'))
            error('PSINS-format AVP/GPS log file error!');
        end
        avp = load(fname);
        n = size(avp,2);
        if n==4 || n==5 % [pos,time] or [pos,tag,time]
            avp(:,1:2) = d2r(avp(:,1:2));
        elseif n==7 || n==8 % [vn,pos,time] or [vn,pos,tag,time]
            avp(:,4:5) = d2r(avp(:,4:5));
        elseif n==10 || n==11 % [att,vn,pos,time] or [att,vn,pos,tag,time]
            avp(:,[1:3,7:8]) = d2r(avp(:,[1:3,7:8]));
        end
    end
