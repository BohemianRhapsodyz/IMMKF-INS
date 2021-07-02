function ddvbm = scullpolyn(wm, vm)
% Calculation of sculling error using polynomial compensation method.
% Ref. Qin Yongyuan 'Inertial Navigation' P336.
%
% Prototype: ddvbm = scullpolyn(wm, vm)
% Inputs: wm - gyro angular increments
%         vm - acc velocity increments
% Output: ddvbm - velocity sculling compensation vector
%
% See also  conepolyn, sculldrift, cnscl.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 29/03/2014
    n = size(wm,1);
    if n==1
        ddvbm = [0,0,0];
    elseif n==2
        ddvbm = 2/3*(cross(wm(1,:),vm(2,:))+cross(vm(1,:),wm(2,:)));
    elseif n==3
        ddvbm = ...
            33/80*(cross(wm(1,:),vm(3,:))+cross(vm(1,:),wm(3,:))) + ...
            57/80*(cross(wm(1,:),vm(2,:))+cross(wm(2,:),vm(3,:))+cross(vm(1,:),wm(2,:))+cross(vm(2,:),wm(3,:)));
    elseif n==4
        ddvbm = ...
            736/945*(cross(wm(1,:),vm(2,:))+cross(wm(3,:),vm(4,:))+cross(vm(1,:),wm(2,:))+cross(vm(3,:),wm(4,:))) + ...
            334/945*(cross(wm(1,:),vm(3,:))+cross(wm(2,:),vm(4,:))+cross(vm(1,:),wm(3,:))+cross(vm(2,:),wm(4,:))) + ...
            526/945*(cross(wm(1,:),vm(4,:))+cross(vm(1,:),wm(4,:))) + ...
            654/945*(cross(wm(2,:),vm(3,:))+cross(vm(2,:),wm(3,:)));
    else
        error('no suitable compensation in scullpolyn');
    end
