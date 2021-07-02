function [dpxyz, idx1] = dposxyz(pos)
% Using pos array to calculate position increment in Cartesian coordinates.
%
% Prototype: dpxyz = dposxyz(pos)
% Input:   pos - position array [lti lon hgt], where 0-pos will be removed.
% Outputs: dpxyz - position increment in Cartesian coordinates
%          idx1 - non-zero position index
%          
% See also  insplot.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 27/06/2018
global glv
    idx1 = (normv(pos(:,1:3))~=0);
    idx0 = ~idx1;
    pos(idx0,1) = pos(idx1(1),1);
    pos(idx0,2) = pos(idx1(1),2);
    pos(idx0,3) = pos(idx1(1),3);
    dpxyz = pos;
    dpxyz(:,1:3) = [[pos(:,1)-pos(1,1),(pos(:,2)-pos(1,2))*cos(pos(1,1))]*glv.Re,pos(:,3)-pos(1,3)];