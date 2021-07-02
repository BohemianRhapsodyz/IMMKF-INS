function data = txtfile(fname, formatstr, data, varargin)
% Save data as txt file.
%
% Prototype: data = txtfile(fname, formatstr, data, infostr1, infostr2, infostr3)
% Inputs: fname - txt file name to be saved 
%         formatstr - format string description for data
%         data - data to be saved
%         varargin - infomation strings attatched to the txt file
% Output: data - data read from txt file

% See also  binfile, imufile, avpfile.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 20/09/2014
    fname = fnamechk(fname, 'txt');
    if nargin>1
        fid = fopen(fname, 'wt');
        if nargin>3, 
            for k=1:length(varargin)
                fprintf(fid, strcat('%',varargin{k},'\r\n'));
            end
        end
        fprintf(fid, strcat(formatstr,'\r\n'), data');
        fclose(fid);
    else
        data = load(fname);
    end
