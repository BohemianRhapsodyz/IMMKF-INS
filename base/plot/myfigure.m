function h = myfigure(namestr)
% Figure of specified characteristic.
%
% Prototype: h = myfigure(namestr)
% Input: namestr - figure name string
% Output: h - handle to this figure
%
% See also  imuplot, insplot, inserrplot, kfplot, POSplot, gpsplot.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 15/02/2014
    scrsz = get(0,'ScreenSize');  % scrsz = [left, bottom, width, height]
    scrsz = [0.01*scrsz(3), 0.05*scrsz(4), 0.95*scrsz(3), 0.93*scrsz(4)];
% 	figure('Position',scrsz);
    if ~exist('namestr','var')
        namestr = 'PSINS Toolbox';
    end
    h0 = figure('OuterPosition',scrsz, 'Name',namestr);
    if nargout==1
        h = h0;
    end