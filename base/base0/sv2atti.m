function [qnb, att, Cnb] = sv2atti(vn, vb, yaw0)
% Using single-measurement vector to determine attitude.
%
% Prototype: [qnb, att, Cnb] = sv2atti(vn, vb, yaw0)
% Inputs: vn - reference vector in nav-frame
%         vb - measurement vector in body-frame
%         yaw0 - initial yaw setting
% Outputs: qnb, att, Cnb - the same attitude representations in 
%               quaternion, Euler angles & DCM form
% Example:
%    [qnb, att, Cnb] = sv2atti(gn, -fb);
%       where gn is gravity vector and fb is acc specific force vector.
%
% See also  dv2atti, mv2atti.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 23/09/2012
    afa = acos(vn'*vb/norm(vn)/norm(vb));
    phi = cross(vb,vn);
    nphi = norm(phi);
%    if cos(afa/2)==0 ...
    if nphi<10e-20
        qnb = [cos(afa/2); sin(afa/2)*[1;1;1]];
    else
        qnb = [cos(afa/2); sin(afa/2)*phi/norm(phi)];
    end
    [qnb, att, Cnb] = attsyn(qnb);
    if nargin>2  % set yaw to yaw0
        att(3) = yaw0;
        [qnb, att, Cnb] = attsyn(att);
    end
