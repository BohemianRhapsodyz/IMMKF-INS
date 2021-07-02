function attc = att2c(att)
% Conventionally, the ranges of roll and yaw are both (-pi,pi] and
% discontinuity occurs when cross +-pi. At those point, we change the 
% angles to continuous regardless range convention. (The discontinuity
% of pitch at +-pi/2 is rare and complicate, we neglect it.)
%
% Prototype: attc = att2c(att)
% Input: att - raw Euler angle data
% Output: attc - continuous Euler angle output
%
% See also  ap2avp, pos2c?.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 15/10/2013, 15/03/2014
    attc = [angle2c(att(:,1)), angle2c(att(:,2)), angle2c(att(:,3))];

function ang = angle2c(ang)
    df = diff(ang);    % find discontinuous points
    g = find(df>pi);   % greater than pi
    s = find(df<-pi);  % smaller than -pi
    for k=1:length(g)
        ang(g(k)+1:end) = ang(g(k)+1:end) - 2*pi;
    end
    for k=1:length(s)
        ang(s(k)+1:end) = ang(s(k)+1:end) + 2*pi;
    end
