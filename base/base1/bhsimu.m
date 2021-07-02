function trj = bhsimu(trj, var, tau, bias, ts, ifplot)
% Height simulation for barometric altimeter using 1st-order
% Markov process.
%
% Prototype: trj = odsimu(trj, inst, kod, qe, dt, ifplot)
% Inputs: trj - from trjsimu
%         var - std of altimeter output, in meter
%         tau - 1st-order Markov process corelated time, in second
%         bias - zero-input output bias, in meter
%         ts - altimeter sampling interval, in second
%         ifplot - plot results after simulation
% Output: trj - the same as trj input, but with the altimeter output
%              field 'bh' attached to this structure array.
%          
% See also  trjsimu, odsimu, gpssimu.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 11/04/2014
    if nargin<6,  ifplot=0;   end
    if nargin<5,  ts=(trj.imu(2,7)-trj.imu(1,7))*10;   end
    if nargin<4,  bias=0;   end
    if nargin<3,  tau=10;   end
    if nargin<2,  var=1;   end
    t = (trj.avp(1,10):ts:trj.avp(end,10))';
    bh = interp1(trj.avp(:,10), trj.avp(:,9), t, 'linear');
    bh = bh + bias + markov1(var, tau, ts, length(bh));
	if ifplot==1,  
        myfigure; plot(t,bh, trj.avp(:,10),trj.avp(:,9)); xygo('H');
	end
    trj.bh = [bh,t];
