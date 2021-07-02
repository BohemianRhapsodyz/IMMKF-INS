function davp = avpseterr(phi, dvn, dpos)
% avp errors setting.
% Inputs: phi - platform misalignment angles. NOTE: leveling errors 
%               phi(1:2) in arcsec, azimuthe error phi(3) in arcmin
%         dvn - velocity errors in m/s
%         dpos - position errors dpos=[dlat;dlon;dhgt], all in m
% Output: davp = [phi; dvn; dpos]
% 
% See also  posseterr, avpadderr, imuerrset, avpset, insupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 08/03/2014
global glv
    phi = phi(:); dvn = dvn(:); dpos = dpos(:);
    if length(phi)==1,   phi = [phi*60; phi*60; phi];   end  % phi is scalar, then all in arcmin
    if length(dvn)==1,   dvn = [dvn; dvn; dvn];      end
    if length(dpos)==1,  dpos = [dpos; dpos; dpos];  end
    davp = [phi(1:2)*glv.sec; phi(3)*glv.min; dvn; posseterr(dpos)];
