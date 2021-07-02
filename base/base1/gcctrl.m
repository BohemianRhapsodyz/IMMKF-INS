function gc = gcctrl(Tdxy, Tdz)
% Calculate gyro-compass control coefficients.
%
% Prototype: gc = gcctrl(Tdxy, Tdz)
% Inputs: Tdxy - time constant for level control
%         Tdz - time constant for azimuth control
% Output: gc - control parameter structure array
%
% See also  aligncmps.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 05/08/2012
global glv
    xi = sqrt(2)/2; % damping coefficient
    ws2 = glv.g0/glv.Re;    % squre of Schuler frequency
    sigma = 2*pi*xi/(Tdxy*sqrt(1-xi^2));    % attenuation coeffcient for kxy1,kxy2,kxy3
    gc.kx1 = 3*sigma; 
    gc.kx2 = sigma^2*(2+1/xi^2)/ws2-1; 
    gc.kx3 = sigma^3/(glv.g0*xi^2);
    if nargin==2
        sigma = 2*pi*xi/(Tdz*sqrt(1-xi^2));  % attenuation coeffcient for kz1,kz2,kz3
        gc.kz1 = 2*sigma; 
        gc.kz4 = gc.kz1; 
        gc.kz2 = 4*sigma^2/ws2-1; 
        gc.kz3 = 4*sigma^4/glv.g0;
    else
        gc.ky1 = gc.kx1; gc.ky2 = gc.kx2; gc.ky3 = gc.kx3;
    end
