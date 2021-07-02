function [kgps, dt] = imugpssyn(k0, k1, ForB)
% SIMU & GPS time synchronization. A schematic diagram for time  
% relationship between SIMU & GPS looks like
%                 k0               k1
%  imu_t:    -----|------*---|-----|--------
%                         <---dt--->     (Forward)
%                 <--dt-->               (Backward)
%  gps_t:    ------------|------------------
%                       kgps
%     where k0,k1 for SIMU data log index and kgps for GPS data log index.
% 
% Prototype: [kgps, dt] = imugpssyn(k0, k1, ForB)
% Usages:
%   For initialization:  imugpssyn(imut, gpst)
%       where imut is SIMU time array, gpst is GPS time array
%   For synchrony checking: [kgps, dt] = imugpssyn(k0, k1, ForB)
%       It checks if there is any GPS sample between SIMU time interval
%       imut(k0) and imut(k1), if exists, return the GPS index 'kgps'
%       and time gap 'dt'. 
%       ForB='F' for forward checking,
%       ForB='B' for backward checking, 
%       ForB='f' for re-setting from the first one,
%       ForB='b' for re-setting from the last one. 
%
% See also  insupdate, kfupdate, POSProcessing.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 03/02/2014
global igaln
    if nargin==2  % initialization: imugpsaln(imut, gpst)
        igaln.imut = k0; igaln.gpst = k1;
        igaln.glen = length(igaln.gpst);
        igaln.kgps = 1;
        return;
    end
    k0 = k0-1;
    if k0==0, k0 = 1; end
    t0 = igaln.imut(k0); t1 = igaln.imut(k1);
    kgps = 0; dt = 0;
    if ForB=='F'  % Forward search
        while igaln.gpst(igaln.kgps)<t0 
            igaln.kgps = igaln.kgps + 1;
            if igaln.kgps>igaln.glen
                igaln.kgps = igaln.glen;
                break;
            end
        end
        tg = igaln.gpst(igaln.kgps);
        if t0<tg && tg<=t1
            kgps = igaln.kgps; dt = t1 - tg;
        end
    elseif ForB=='B' % Backward search
        while igaln.gpst(igaln.kgps)>t1 
            igaln.kgps = igaln.kgps - 1;
            if igaln.kgps==0
                igaln.kgps = 1;
                break;
            end
        end
        tg = igaln.gpst(igaln.kgps);
        if t0<=tg && tg<t1
            kgps = igaln.kgps; dt = tg - t0;
        end
    elseif ForB=='f'  % Forward re-intialization, set to the first one
        igaln.kgps = 1;
    elseif ForB=='b'  % Backward re-intialization, set to the last one
        igaln.kgps = igaln.glen;
    end