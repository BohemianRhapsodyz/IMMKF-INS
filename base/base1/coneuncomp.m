function dphim = coneuncomp(wm)
% Calculation of noncommutativity error using uncompressed coning algorithm.
% Ref. SongMin PhD thesis P47 tab.3.1.
%
% Prototype: dphim = coneuncomp(wm)
% Input: wm - gyro angular increments
% Output: dphim - noncommutativity error compensation vector
%
% See also  conepolyn, conetwospeed, conedrift, scullpolyn, cnscl.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 03/02/2017
    n = size(wm,1);
    if n==1
        dphim = [0,0,0];
    elseif n==2
        dphim = 2/3*cros(wm(1,:),wm(2,:));
    elseif n==3
        dphim = ...
            27/40*cros(wm(2,:),wm(3,:)) + 9/20*cros(wm(1,:),wm(3,:)) + ...
            27/40*cros(wm(1,:),wm(2,:));
    elseif n==4
        dphim = ...
            232/315*cros(wm(3,:),wm(4,:)) +  46/105*cros(wm(2,:),wm(4,:)) + ...
              18/35*cros(wm(1,:),wm(4,:)) + 178/315*cros(wm(2,:),wm(3,:)) + ...
             46/105*cros(wm(1,:),wm(3,:)) + 232/315*cros(wm(1,:),wm(2,:));
    elseif n==5
        dphim = ...
            18575/24192*cros(wm(4,:),wm(5,:)) +   2675/6048*cros(wm(3,:),wm(5,:)) + ...
            11225/24192*cros(wm(2,:),wm(5,:)) +     125/252*cros(wm(1,:),wm(5,:)) + ...
              2575/6048*cros(wm(3,:),wm(4,:)) +     425/672*cros(wm(2,:),wm(4,:)) + ...
            13975/24192*cros(wm(1,:),wm(4,:)) +   1975/3024*cros(wm(2,:),wm(3,:)) + ...
               325/1512*cros(wm(1,:),wm(3,:)) + 21325/24192*cros(wm(1,:),wm(2,:));
    else
        dphim = [0,0,0];
%         error('no suitable compensation in conepolyn');
    end