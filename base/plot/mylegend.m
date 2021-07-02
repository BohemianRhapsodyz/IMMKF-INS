function mylegend(str1, str2, str3, str4, str5)
% Legend of specified characteristic.
%
% Prototype: myfigure(str1, str2, ...)
% Inputs: str1,str2 - strings for legend
%
% See also  lbdef.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 20/05/2014
    location = 'NorthEast';
    switch nargin
        case 1,
            str1 = lbdef(str1);
            legend(str1, 'Location', location);
        case 2,
            str1 = lbdef(str1); str2 = lbdef(str2);
            legend(str1, str2, 'Location', location);
        case 3,
            str1 = lbdef(str1); str2 = lbdef(str2); str3 = lbdef(str3);
            legend(str1, str2, str3, 'Location', location);
        case 4,
            str1 = lbdef(str1); str2 = lbdef(str2); str3 = lbdef(str3);
            str4 = lbdef(str4);
            legend(str1, str2, str3, str4, 'Location', location);
        case 5,
            str1 = lbdef(str1); str2 = lbdef(str2); str3 = lbdef(str3);
            str4 = lbdef(str4); str5 = lbdef(str5);
            legend(str1, str2, str3, str4, str5, 'Location', location);
    end
    
function str = lbdef(str)
    str = labeldef(str);
    idx = strfind(str, '/');
    if ~isempty(idx)
        str = str(1:idx(1)-1);
    end
