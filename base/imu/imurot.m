function wvm = imurot(wvm0, rot)
% Rotate SIMU's b-frame by a small angle vector: rot=[rotX; rotY; rotZ].
%
% Prototype: wvm = imurot(wvm0, rot)
% Inputs: wvm0 - the user's raw SIMU data
%         rot - rot=[rotX; rotY; rotZ] are usually small angles 
% Output: wvm - SIMU data output after rotation
%
% See also  imurfu, imuresample, imuadderr, insupdate, trjsimu.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 02/10/2014
    wvm = wvm0;
    Cb0b1 = a2mat(rot);  % Cnb
    wvm(:,1:6) = [wvm0(:,1:3)*Cb0b1, wvm0(:,4:6)*Cb0b1];
