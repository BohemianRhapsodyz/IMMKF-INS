function dr = drinit(avp0, inst, kod, ts)
% Dead Reckoning(DR) structure array initialization.
%
% Prototype: dr = drinit(avp0, inst, ts)
% Inputs: avp0 - initial avp0 = [att0; vn0; pos0]
%         inst - ints=[dpitch;0;dyaw], where dpitch and dyaw are
%            installation error angles(in rad) from odometer to SIMU
%         kod - odometer scale factor in meter/pulse.
%         ts - SIMU % odometer sampling interval
% Output: dr - DR structure array
%
% See also  drupdate, drcalibrate, insinit.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 17/12/2008, 8/04/2014
	dr = [];
    avp0 = avp0(:);
	dr.qnb = a2qua(avp0(1:3)); dr.vn = zeros(3,1); dr.pos = avp0(7:9);
    [dr.qnb, dr.att, dr.Cnb] = attsyn(dr.qnb);
    dr.avp = [dr.att; dr.vn; dr.pos];
	dr.kod = kod;
    dr.Cbo = a2mat(-inst)*kod;
	dr.prj = dr.Cbo*[0;1;0]; % from OD to SIMU
	dr.ts = ts;
	dr.distance = 0;
	dr.eth = earth(dr.pos);
    dr.Mpv = [0, 1/dr.eth.RMh, 0; 1/dr.eth.clRNh, 0, 0; 0, 0, 1];

