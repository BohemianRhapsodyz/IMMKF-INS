function vbl = vn2vbl(Cnb, vn)
% Convert vector expressed in n-frame to b-level-frame.
%
% Prototype: vbl = vn2vbl(Cnb, vn)
% Inputs: Cnb - SINS attitude DCM, (or Cnb=yaw)
%         vn - vector expressed in n-frame
% Output: vbl - vector expressed in b-level-frame
%
% See also  m2att.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 03/12/2014
    if length(Cnb)==1  % vbl = vn2vbl(yaw, vn)
        syaw = sin(Cnb); cyaw = cos(Cnb);
    else
        spitch = Cnb(3,2);
        cpitch = sqrt(1-spitch*spitch);
        syaw = -Cnb(1,2)/cpitch;
        cyaw = Cnb(2,2)/cpitch;
    end
    vbl = [cyaw*vn(1)+syaw*vn(2); -syaw*vn(1)+cyaw*vn(2); vn(3)];