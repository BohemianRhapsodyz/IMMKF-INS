function pos2gpx(fname, pos)
% Create a simple *.gpx file appling to Google Earth to show tracks.
%
% Prototype: pos2gpx(fname, pos)
% Inputs: fname - file name, with default extension '.gpx'
%         pos - geographic position [lat,lon,hgt] array
% Notes: the steps of loading *.gpx file to Google Earth are
%   1) start Google Earth
%   2) in Google Earth menu: File->Open
%   3) in Open dialog: Select this generated *.gpx file->Open
%
% See also  gpsplot, avpfile.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 10/08/2011, 14/03/2014
    % fname = fnamechk(fname, 'gpx');
    pos = [r2d(pos(:,1:2)), pos(:,3)];
    t = (1:length(pos))';
    t = datestr(datenum(2014,3,14,0,0,t),13);
%     t = datestr(datenum(2014,3,14,0,0,t));
    fid = fopen(fname, 'wt');
    fprintf(fid, '<?xml version="1.0"?>\n');
    fprintf(fid, '<gpx\n');
    fprintf(fid, 'version="1.1"\n');
    fprintf(fid, 'creator="PSINS Toolbox"\n');
    fprintf(fid, 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"\n');
    fprintf(fid, 'xmlns="http://www.topografix.com/GPX/1/1"\n');
    fprintf(fid, 'xsi:schemaLocation="http://www.topografix.com/GPX/1/1/gpx.xsd">\n');
    fprintf(fid, '<trk>\n');
    fprintf(fid, '<name>converted</name>\n');
    fprintf(fid, '<trkseg>\n');
    for k=1:length(pos)
        fprintf(fid, '<trkpt lat="%.6f" lon="%.6f">\n', pos(k,1), pos(k,2));
        fprintf(fid, '<ele>%.6f</ele>\n',pos(k,3));
        fprintf(fid, '<time>2014-03-14T%sZ</time>\n', t(k,:));
%         fprintf(fid, '<time>%s</time>\n', t(k,:));
        fprintf(fid, '</trkpt>\n');
    end
    fprintf(fid, '</trkseg>\n');
    fprintf(fid, '</trk>\n');
    fprintf(fid, '</gpx>\n');
    fclose(fid);
