function [veldrift, scullm] = sculldrift(nn, ts, Ae, Ap, f)
% Calculate the residual velocity drift rate of sculling compensation.
%
% Prototype: [veldrift, scullm] = sculldrift(nn, ts, Ae, Ap, f)
% Inputs: nn - subsample number
%         ts - sampling interval
%         Ae - angular amplitude (in rad)
%         Ap - linear displacement amplitude (in m)
%         f - coning frequency (in Hz)
% Outputs: veldrift - velocity drift rate in m/s/s
%          scullm - sculling error in m/s/s
%
% See also  scullsimu, conedrift, conecoef, cnscl, insupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 28/03/2014
global glv
    omega = 2*pi*f;
    veldrift = conedrift(nn, ts, sqrt(Ae*Ap*omega), f);
    % direct simulation method, regardless of small Ae or Ap
    nts = nn*ts;
    wvm = scullsimu(Ae, Ap, f, ts, nts);
    wm = wvm(:,1:3); vm = wvm(:,4:6);
    if nn>1
        cm = glv.cs(nn-1,1:nn-1)*wm(1:nn-1,:);
        sm = glv.cs(nn-1,1:nn-1)*vm(1:nn-1,:);
    else
        cm = [0, 0, 0]; sm = cm;
    end
	scullmc = (cross(cm,vm(nn,:))+cross(sm,wm(nn,:)));  % calculated sculling error
    scullm = 1/2*Ae*Ap*omega*(omega*nts-sin(omega*nts)); % theoretical error
    veldrift(2,1) = (scullm-abs(scullmc(3)))/nts;
    scullm = scullm/nts;
