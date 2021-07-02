function [Cbs, K] = Ks2Cbs(Ks)
% Calculate install matrix and scale factor from calibration matirx.
%
% Prototype: [Cbs, K] = Ks2Cbs(Ks)
% Inputs: Ks - gyro calibration matrix Ka (or acc calibration matrix Ka)
% Outputs: Cbs - gyro install matrix Cbg (or acc install matrix Cba)
%          K - gyro scale factor (or acc scale factor)
%
% See also  sumn, avar.

% Copyright(c) 2009-2016, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 24/10/2016
    Ki = Ks^-1;
    K = [norm(Ki(1,:)); norm(Ki(2,:)); norm(Ki(3,:))];
    Cbs = [Ki(1,:)/K(1); Ki(2,:)/K(2); Ki(3,:)/K(3)]';