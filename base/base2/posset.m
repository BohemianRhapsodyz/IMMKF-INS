function pos = posset(pos0, lon, hgt)
% Geographic position = [latitude; logititude; height] setting.
%
% Prototype: pos = posset(pos0, lon, hgt)
% Input: pos0=[lat; lon; height], where lat and lon are always in arcdeg,
%             but if |lat|<pi/2 && |lon|<=pi, the unit is regarded as rad;
%             where height is in m.
%           or pos0=[lat; lon; hgt].
% Output: pos=[pos0(1)*arcdeg; pos0*arcdeg; dpos0(3)]
% 
% See also  avpset, posseterr.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 09/03/2014
    % causion: it can't set abs(lat)<pi/2 && abs(lon)<pi with unit arcdeg.
    if nargin==3,  pos0 = [pos0; lon; hgt];  end
    if abs(pos0(1))>=pi/2 || abs(pos0(2))>pi
        pos0(1:2) = d2r(pos0(1:2));
    end
    pos = pos0; 