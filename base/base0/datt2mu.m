function mu = datt2mu(datt, att0)
% Calculate the installation error angles(expressed in body-frame) 
% form attitude 'att0' and attitude error 'datt'.
%
% Prototype: mu = datt2mu(datt, att0)
% Inputs: datt - Euler angles error vector
%         att0 - reference Euler angles att0=[pitch0;roll0;yaw0]
% Output: mu - installation error angles mu=[mux;muy;muz]
%
% See also  aa2mu, aa2phi.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 05/10/2014
    att1 = att0(:,1:3) + datt(:,1:3);
    mu = aa2mu(att1, att0);

