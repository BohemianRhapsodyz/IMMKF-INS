function pos = cen2pos(Cen)
% Convert transformation matrix Cen to geographic pos = [lat; lon; *].
%
% Prototype: pos = cen2pos(Cen)
% Input: Cen - transformation matrix from Earth-frame to nav-frame
% Output: pos - geographic position
%
% See also  pos2cen, blh2xyz, xyz2blh, a2mat, pp2vn.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 05/05/2010
    pos = [asin(Cen(3,3)); atan2(Cen(2,3), Cen(1,3)); 0];
