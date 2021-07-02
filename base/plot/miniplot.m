function miniplot(data, str)
% A mini plot function
%
% Prototype: miniplot(data, str)
% Inputs: data - data to plot, 
%         str - flag string
%
% See also  labeldef.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 29/07/2017
global glv
    sz = size(data,2);
    figure;
    switch str
        case 'p',
            if sz>2, sz=2; data=data(:,[1,end]); end
            sz1=1; data(:,1:sz1)=data(:,1:sz1)/glv.deg;
        case 'r',
            if sz>2, sz=2; data=data(:,[2,end]); end
            sz1=1; data(:,1:sz1)=data(:,1:sz1)/glv.deg;
        case 'pr',
            if sz>3, sz=3; data=data(:,[1:2,end]); end
            sz1=2; data(:,1:sz1)=data(:,1:sz1)/glv.deg;
        case 'att',
            if sz>4, sz=4; data=data(:,[1:3,end]); end
            sz1=3; data(:,1:sz1)=data(:,1:sz1)/glv.deg;
        case 'VEN',
            if sz>3, sz=3; data=data(:,[4:5,end]); end
            sz1=2;
        case 'VU',
            if sz>2, sz=2; data=data(:,[6,end]); end
            sz1=1;
        case 'V',
            if sz>4, sz=4; data=data(:,[4:6,end]); end
            sz1=3;
        case 'eb',
            if sz>4, sz=4; data=data(:,[10:12,end]); end
            sz1=3; data(:,1:sz1)=data(:,1:sz1)/glv.dph;
        case 'db',
            if sz>4, sz=4; data=data(:,[13:15,end]); end
            sz1=3; data(:,1:sz1)=data(:,1:sz1)/glv.ug;
    end
    if sz==sz1, plot(data(:,1:sz1)); 
    else, plot(data(:,end), data(:,1:sz-1)); end
    xygo(str);
