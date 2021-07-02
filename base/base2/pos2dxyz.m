function dxyz = pos2dxyz(pos, pos0)
% Transfer [lat,lon,hgt] to [dx,dy,dz].
%
% Prototype: dxyz = pos2dxyz(pos)
% Inputs: pos - [lat, lon, hgt, t]
% Outputs: dxyz - [dx, dy, dz] , Cartesian coordinates(E-N-U in meters) relative to pos0
%
% See also  RMRN, pos2dplot.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 19/06/2017
    if nargin<2, pos0 = pos(1,1:3)'; end;
    [RMh, clRNh] = RMRN(pos);
    if size(pos,2)==3, pos(:,4) = (1:size(pos,1))'; end
%     dxyz = [(pos(:,2)-pos0(2)).*RMh, (pos(:,1)-pos0(1)).*clRNh, pos(:,3)-pos0(3), pos(:,end)];
    dxyz = [(pos(:,2)-pos0(2)).*clRNh, (pos(:,1)-pos0(1)).*RMh, pos(:,3)-pos0(3), pos(:,end)];

