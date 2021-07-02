function avp = avpadderr(avp0, davp)
% avp add some errors, it can be denoted as avp=avp0+davp, where
% avp0=[att0;vn0;pos0] and davp=[phi;dvn;dpos].
%
% Prototype: avp = avpadderr(avp0, davp)
% Inputs: avp0 - avp0=[att0;vn0;pos0], avp initial values
%         davp - davp=[phi;dvn;dpos], avp errors
% Output: avp - avp=[att; vn; pos], avp with errors
% 
% See also  avpseterr, imuadderr, qaddphi, avpcmp, avpinterp, insupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 07/03/2014
    avp0 = avp0(:); davp = davp(:);
	[phi, dvn, dpos] = setvals(davp(1:3), davp(4:6), davp(7:9));
    avp(1:3,1) = q2att(qaddphi(a2qua(avp0(1:3)), phi));
    avp(4:9,1) = avp0(4:9)+[dvn; dpos];
