function [phim, afam, betam] = conetwospeed(Dafa)
% Two-speed coning compensation. Ref. Savage, 1998, 'Strapdown Inertial 
% Navigation Integration Algorithm Design Part 1: Attitude Algorithms',
% Eq.(46)-(47).
%
% Prototype: [phim, afam, betam] = conetwospeed(Dafa)
% Input: Dafa - gyro angular increments, including m subsamples
% Outputs: phim - rotation vector = afam + betam
%          afam - total angular increment
%          betam - coning compensation

% See also  conepolyn, conecoef, conedrift, cnscl.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 11/04/2014
global glbtwospeed
    m = size(Dafa,1);
    o13 = zeros(1,3);
    if isempty(glbtwospeed),  glbtwospeed.DafaL_1 = o13;  end
    DafaL_1 = glbtwospeed.DafaL_1; afaL_1 = o13; betaL_1 = o13;
    for L=1:m
        DafaL = Dafa(L,1:3);
        afaL = afaL_1 + DafaL;
        DbetaL = 1/2.0*cross((afaL_1+1/6.0*DafaL_1),DafaL);
        betaL = betaL_1 + DbetaL;
        DafaL_1 = DafaL;  afaL_1 = afaL;  betaL_1 = betaL;
    end
    glbtwospeed.DafaL_1 = DafaL;
    afam = afaL';  betam = betaL';
    phim = afam + betam;
    