function dpos = vn2dpos(eth, vn, ts)
% Convert velocity to position increment within time interval 'ts'.
%
% Prototype: dpos = vn2dpos(eth, vn, ts)
% Inputs: eth - Earth parameter structure array
%         vn - nav-frame velocity with respect to earth-frame
%         ts - time interval to calculate position increment
% Output: dpos - position increment, dpos=[dlat;dlon;dhgt]
%              where dlat & dlon are in radians, dhgt in meter
%
% See also  pp2vn, la2dpos, earth.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 27/08/2013
    if nargin<3  % dpos = vn2dpos(eth, lever_n)
        dpos = [vn(2)/eth.RMh; vn(1)/eth.clRNh; vn(3)];
        return;
    end
    dpos = [vn(2)/eth.RMh; vn(1)/eth.clRNh; vn(3)]*ts;