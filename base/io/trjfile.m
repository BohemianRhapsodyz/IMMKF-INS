function trj = trjfile(fname, trj)
% Save or load trajectory *.mat file.
%
% Prototype: trj = trjfile(fname, trj)
% Inputs: fname - file name, with default extension '.mat'
%         trj - trajectory array, always including fields: imu, avp, 
%               avp0 and ts
% Output: trj - trajectory array read from the file
% Usages: 
%    Save: trjfile(fname, trj)
%    Read: trj = trjfile(fname)
%
% See also  imufile, avpfile, binfile.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 21/03/2014
    fname = fnamechk(fname, 'mat');
    if nargin<2  % load
        trj = load(fname);
        trj = trj.trj;
    else  % save
        save(fname, 'trj');
    end
