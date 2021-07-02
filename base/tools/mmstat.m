function [vmax, vmin] = mmstat(vmax, vmin, val, ts, tau)
% Maximum & minimum value statics.
    if val>vmax,       vmax = val;
    elseif val<vmin    vmin = val;
    end
    if tau<ts, tau = 2*ts; end
    coef = 1-ts/tau;
    vmean = (vmin+vmax)/2;
    temp = coef*(vmax-vmean)+vmean;  % vmax
    vmin = coef*(vmin-vmean)+vmean;
    vmax = temp;

