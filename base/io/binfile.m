function data1 = binfile(fname, data, row0, row1)
% Save or load double format binary file, it can be exchange with C
% language. When loaded, be sure of the acurate number of data columns.
%
% Prototype: data1 = binfile(fname, data)
% Inputs: fname - file name, with default extension '.bin'
%         data - binary data array to save, but for read process 'data'
%                is the column number of the data saved.
% Output: data1 - data array read from the binary file
% Usages: 
%    Save: binfile(fname, data)
%    Read: data1 = binfile(fname, column)

% See also  imufile, avpfile.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 20/02/2013, 30/03/2015
    fname = fnamechk(fname, 'bin');
    if length(data)==1 % load: data1 = binfile(fname, columns)
        if nargin<3, row0=0; row1=inf; end
        if nargin==3, row1=row0; row0=0; end
        columns = data;
        fid = fopen(fname, 'rb');
        if row0>0, fseek(fid, columns*row0*8, 'bof'); end
        data1 = fread(fid, [columns,row1-row0], 'double')';
    else               % save: binfile(fname, data)
        fid = fopen(fname, 'wb');
        fwrite(fid, data', 'double');
    end
    fclose(fid);
