function dr = drupdate(dr, wm, dS)
% Dead Reckoning(DR) attitude and position updating.
%
% Prototype: dr = drupdate(dr, imu, dS)
% Inputs: dr - DR structure array, created by 'drinit'
%         wm - SIMU gyro sampling data
%         dS - odometer distance increment
% Output: dr - DR structure array after DR updating
%
% See also  drinit, drcalibrate, insupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 17/12/2008, 8/04/2014
    nts = dr.ts*size(wm,1);
    dr.distance = dr.distance + dr.kod*norm(dS);
    phim = cnscl(wm);
    if length(dS)>1,
        dSn = qmulv(dr.qnb, dr.Cbo*dS);
    else
        dSn = qmulv(dr.qnb, dr.prj*dS);
    end
    dr.vn = dSn/nts;
    dr.eth = earth(dr.pos, dr.vn);
    dr.web = phim/nts-dr.Cnb'*dr.eth.wnie;
    dr.Mpv = [0, 1/dr.eth.RMh, 0; 1/dr.eth.clRNh, 0, 0; 0, 0, 1];
    dr.pos = dr.pos + dr.Mpv*dSn; % see my PhD thesis Eq.(4.1.1)
    dr.qnb = qupdt(dr.qnb, phim-dr.Cnb'*dr.eth.wnin*nts);
    [dr.qnb, dr.att, dr.Cnb] = attsyn(dr.qnb);
    dr.avp = [dr.att; dr.vn; dr.pos];
