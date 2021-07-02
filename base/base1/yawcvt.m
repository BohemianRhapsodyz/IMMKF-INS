function yaw = yawcvt(yaw, cvstr)
% Euler yaw angles convertion to designated convension.
%
% Prototype: yaw = yawcvt(yaw, dirstr)
% Inputs: yaw - input yaw angles, in rad
%         dirstr - convention descript string
% Output: yaw - output yaw angles in new convention
%
% Examples:
%         glvs
%         y=mod((0:400)',360)*glv.deg;       figure, plot([y, yawcvt(y,'c360cc180')]/glv.deg); grid on
%         y=(mod((0:400)',360)-180)*glv.deg;  figure, plot([y, yawcvt(y,'cc180c360')]/glv.deg); grid on
% See also  m2att, q2att.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 30/05/2014, 25/02/2017
    switch cvstr
        % 360 -> 180
        case 'c360cc180',  %****** clockwise 0->360deg to counter-clockwise -180->180deg
            yaw = mod(yaw,2*pi);
            idx = yaw>pi;
            yaw(idx) = 2*pi-yaw(idx);
            yaw(~idx) = -yaw(~idx);
        case 'c360c180',  % clockwise 0->360deg to clockwise -180->180deg
            yaw = -yawcvt(yaw, 'c360cc180');
        case 'cc360cc180',  % counter-clockwise 0->360deg to counter-clockwise -180->180deg
            yaw = -yawcvt(yaw, 'c360cc180');
        % 180 -> 360    
        case 'cc180c360',  %****** counter-clockwise -180->180deg to clockwise 0->360deg
            yaw = mod(yaw+pi, 2*pi)-pi;
            idx = yaw>0;
            yaw(idx) = 2*pi-yaw(idx);
            yaw(~idx) = -yaw(~idx);
        case 'cc180cc360',  % counter-clockwise -180->180deg to counter-clockwise 0->360deg
            yaw = 2*pi-yawcvt(yaw, 'cc180c360');
    end
