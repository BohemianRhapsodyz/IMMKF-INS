function txtfilecut(infname, outfname, lines)
% Extract lines from txt file to form a new txt file.
%
% Prototype: txtfilecut(infname, outfname, lines)
% Inputs: infname - input txt file name
%         outfname - output/new txt file name
%         lines - start line and end line

% See also  txtfile.

% Copyright(c) 2009-2015, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 19/04/2015
    fid0 = fopen(infname, 'rt');
    fid1 = fopen(outfname, 'wt');
    for k=1:lines(1)-1, fgetl(fid0);  end;
    for k=lines(1):lines(2)
        tline = fgetl(fid0);
        if ~ischar(tline), break; end
        fprintf(fid1, '%s\n', tline);
    end
    fclose(fid0);
    fclose(fid1);
