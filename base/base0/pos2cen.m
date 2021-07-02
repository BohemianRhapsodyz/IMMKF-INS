function Cen = pos2cen(pos)
% Convert geographic pos = [lat; lon; *] to transformation matrix Cen (
% from Earth-frame to nav-frame £©.
%
% Prototype: Cen = pos2cne(pos)
% Input: pos - geographic position
% Output: Cen - transformation matrix from Earth-frame to nav-frame
%
% See also  cen2pos, blh2xyz, xyz2blh, a2mat, pp2vn.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 05/05/2010
    slat = sin(pos(1)); clat = cos(pos(1));
    slon = sin(pos(2)); clon = cos(pos(2));
    Cen = [ -slon,  -slat*clon,  clat*clon
             clon,  -slat*slon,  clat*slon
             0,      clat,       slat      ];
