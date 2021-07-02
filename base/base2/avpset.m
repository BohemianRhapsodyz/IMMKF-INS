function avp = avpset(att, vn, pos)
% avp=[attitude; velocity; position] setting.
%
% Prototype: avp = avpset(att, vn, pos)
% Inputs: att - attitude in deg
%        vn - velocity in m/s
%        pos - postion=[lat;lon;height] with lat and lon in deg,
%              while heigth in m. see posset.
% Output: avp=[attitude; velocity; position]
% 
% See also  posset, avpseterr, avpadderr, insupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 08/03/2014
    if length(att)==1,  att = [att; att; att];  end
    if length(vn)==1,   % vn is scalar, representing the forward velocity
        vb = [0; vn; 0];
        vn = a2mat(d2r(att(:)))*vb;
    end
    avp = [d2r(att(:)); vn(:); posset(pos(:))];
