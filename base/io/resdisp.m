function resdisp(infostr, val)
% Display the result associated with a pre-leading information string.
%
% Prototype: resdisp(infostr, val)
% Inputs: infostr - pre-leading information string
%         val - value to display
%
% See also  timebar.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 10/03/2014
    disp(' ');
    disp([infostr ' :']);
    disp(val);
