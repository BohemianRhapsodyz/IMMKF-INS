function fname = fnamechk(fname, ext)
% Check file name, adding path and extension, if nessesary.
%
% Prototype: fname = fnamechk(fname, ext)
% Inputs: fname - file name
%         ext - file name extension
% Output: fname - file name output with adequate path and extension
%
% See also  imufile, avpfile, pos2gpx.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 18/03/2014
global glv
    if isempty(strfind(fname, '.'))
        fname = [fname, '.', ext]; 
    end
    if ~exist(['.\',fname],'file')
        fname = [glv.datapath, fname];
    end
