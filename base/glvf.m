function glv1 = glvf(Re, f, wie)
% PSINS Toolbox global variable structure initialization.
%
% Prototype: glv = glvf(Re, f, wie)
% Inputs: Re - the Earth's semi-major axis
%         f - flattening
%         wie - the Earth's angular rate
% Output: glv1 - output global variable structure array
%
% See also  psinsinit.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 14/08/2011, 10/09/2013, 09/03/2014
global glv
    if ~exist('Re', 'var'),  Re = [];  end
    if ~exist('f', 'var'),   f = [];  end
    if ~exist('wie', 'var'), wie = [];  end
    if isempty(Re),  Re = 6378137;  end
    if isempty(f),   f = 1/298.257;  end
    if isempty(wie), wie = 7.2921151467e-5;  end
    glv.Re = Re;                    % the Earth's semi-major axis
    glv.f = f;                      % flattening
    glv.Rp = (1-glv.f)*glv.Re;      % semi-minor axis
    glv.e = sqrt(2*glv.f-glv.f^2); glv.e2 = glv.e^2; % 1st eccentricity
    glv.ep = sqrt(glv.Re^2-glv.Rp^2)/glv.Rp; glv.ep2 = glv.ep^2; % 2nd eccentricity
    glv.wie = wie;                  % the Earth's angular rate
    glv.meru = glv.wie/1000;        % milli earth rate unit
    glv.g0 = 9.7803267714;          % gravitational force
    glv.mg = 1.0e-3*glv.g0;         % milli g
    glv.ug = 1.0e-6*glv.g0;         % micro g
    glv.mGal = 1.0e-3*0.01;         % milli Gal = 1cm/s^2 ~= 1.0E-6*g0
    glv.ugpg2 = glv.ug/glv.g0^2;    % ug/g^2
    glv.ws = 1/sqrt(glv.Re/glv.g0); % Schuler frequency
    glv.ppm = 1.0e-6;               % parts per million
    glv.deg = pi/180;               % arcdeg
    glv.min = glv.deg/60;           % arcmin
    glv.sec = glv.min/60;           % arcsec
    glv.hur = 3600;                 % time hour (1hur=3600second)
    glv.dps = pi/180/1;             % arcdeg / second
    glv.dph = glv.deg/glv.hur;      % arcdeg / hour
    glv.dpss = glv.deg/sqrt(1);     % arcdeg / sqrt(second)
    glv.dpsh = glv.deg/sqrt(glv.hur);  % arcdeg / sqrt(hour)
    glv.dphpsh = glv.dph/sqrt(glv.hur); % (arcdeg/hour) / sqrt(hour)
    glv.Hz = 1/1;                   % Hertz
    glv.dphpsHz = glv.dph/glv.Hz;   % (arcdeg/hour) / sqrt(Hz)
    glv.ugpsHz = glv.ug/sqrt(glv.Hz);  % ug / sqrt(Hz)
    glv.ugpsh = glv.ug/sqrt(glv.hur); % ug / sqrt(hour)
    glv.mpsh = 1/sqrt(glv.hur);     % m / sqrt(hour)
    glv.mpspsh = 1/1/sqrt(glv.hur); % (m/s) / sqrt(hour), 1*mpspsh~=1700*ugpsHz
    glv.ppmpsh = glv.ppm/sqrt(glv.hur); % ppm / sqrt(hour)
    glv.mil = 2*pi/6000;            % mil
    glv.nm = 1853;                  % nautical mile
    glv.kn = glv.nm/glv.hur;        % knot
    %%
    glv.wm_1 = [0,0,0]; glv.vm_1 = [0,0,0];   % the init of previous gyro & acc sample
    glv.cs = [                      % coning & sculling compensation coefficients
        [2,    0,    0,    0,    0    ]/3
        [9,    27,   0,    0,    0    ]/20
        [54,   92,   214,  0,    0    ]/105
        [250,  525,  650,  1375, 0    ]/504 
        [2315, 4558, 7296, 7834, 15797]/4620 ];
    glv.csmax = size(glv.cs,1)+1;  % max subsample number
    glv.v0 = [0;0;0];    % 3x1 zero-vector
    glv.qI = [1;0;0;0];  % identity quaternion
    glv.I33 = eye(3); glv.o33 = zeros(3);  % identity & zero 3x3 matrices
    glv.pos0 = [34.248937*glv.deg; 108.891913*glv.deg; 380]; % position of INSLAB
    glv.eth = []; glv.eth = earth(glv.pos0);
    %%
    [glv.rootpath, glv.datapath, glv.mytestflag] = psinsenvi;
    glv1 = glv;

