function trj = odsimu(trj, inst, kod, qe, dt, ifplot)
% Odometer distance increment simulator. (In this version, the lever-arm
% between odometer and SIMU is not considered.)
%
% Prototype: trj = odsimu(trj, inst, kod, qe, dt, ifplot)
% Inputs: trj - from trjsimu
%         inst - installation error angles from odometer(vehicle) to SIMU,
%              inst=[dpitch;droll;dyaw] in arcmin, default 0 for no 
%              installation error
%         kod - odometer scale factor, default 1 for no scale factor error
%         qe - quantitative equivalent, default 0 for no quantization
%         dt - odometer time delay w.r.t. SIMU, >0 for laging; <0 for 
%              leading, the default value is 0
%         ifplot - plot results after simulation
% Output: trj - the same as trj input, but with trj.imu, Eular angles 
%              trj.avp0(:,1:3) and trj.avp(:,1:3) rotated due to 
%              installation errors, besides, the Odometer increment field
%              'od' is attached to this structure.
%          
% See also  trjsimu, bhsimu, gpssimu.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 19/02/2014
    if nargin<6,  ifplot=0;   end
    if nargin<5,  dt=0;   end
    if nargin<4,  qe=0;   end   % default 0 meter/pulse, for no quantization
    if nargin<3,  kod=1;   end   % default 1 for no scale factor error
    if nargin<2,  inst=0;   end
    if length(inst)==1,  inst=[1;1;1]*inst;  end
    Cb1b0 = a2mat(-d2r(inst/60));  Cb0b1 = Cb1b0';
    % SIMU rotation
    trj.imu(:,1:6) = [trj.imu(:,1:3)*Cb1b0', trj.imu(:,4:6)*Cb1b0'];
    % attitude rotation
    trj.avp0(1:3) = m2att(a2mat(trj.avp0(1:3))*Cb0b1);
    for k=1:length(trj.avp)
        trj.avp(k,1:3) = m2att(a2mat(trj.avp(k,1:3)')*Cb0b1)';
    end
    % distance increments
    pos = [trj.avp0(7:9)'; trj.avp(:,7:9)];
    [RMh, clRNh] = RMRN(pos);
    dpos = diff(pos);
    dxyz = [[RMh(1:end-1), clRNh(1:end-1)].*dpos(:,1:2), dpos(:,3)];
    dS = sqrt(sum(dxyz.^2,2));
    t = trj.avp(:,10);
    dS = interp1([t(1)-1;t;t(end)+1],[dS(1);dS;dS(end)], t+dt); % time delay
    dS = cumsum([0;dS]);
    if qe==0
        dS = diff(dS*kod);
        if ifplot==1,  myfigure; plot(t,dS); xygo('Odometer / m');  end
    else
        dS = fix(diff(dS*kod/qe));
        if ifplot==1,  myfigure; plot(t,dS); xygo('Odometer / pulse');  end
    end
    trj.od = [dS,t];
