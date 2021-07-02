function qnb = a2qua(att)
% Convert Euler angles to attitude quaternion.
%
% Prototype: qnb = a2qua(att)
% Input: att - att=[pitch; roll; yaw] in radians
% Output: qnb - attitude quaternion
%
% See also  a2mat, m2att, m2qua, q2att, q2mat, attsyn, rv2q.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 21/02/2008, 19/03/2014

%     qnb = m2qua(a2mat(att))

%     att2 = att/2; att2(3) = -att2(3);
%     s = sin(att2); c = cos(att2);
%     qnb = [ c(3)*c(2)*c(1) + s(3)*s(2)*s(1);  % ZhangShuxia P58, sign incorrect in the book
%             c(3)*c(2)*s(1) + s(3)*s(2)*c(1);
%             c(3)*s(2)*c(1) - s(3)*c(2)*s(1);
%            -s(3)*c(2)*c(1) + c(3)*s(2)*s(1) ]
    
    att2 = att/2;
    s = sin(att2); c = cos(att2);
    sp = s(1); sr = s(2); sy = s(3); 
    cp = c(1); cr = c(2); cy = c(3); 
    qnb = [ cp*cr*cy - sp*sr*sy;
            sp*cr*cy - cp*sr*sy;
            cp*sr*cy + sp*cr*sy;
            cp*cr*sy + sp*sr*cy ];