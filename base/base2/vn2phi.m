function phi = vn2phi(vn, lti, ts)
% Calculating misalign angles from pure SINS velocity error.
%
% Prototype: phi = vn2phi(vn, lti, ts)
% Inputs: vn - pure SINS velocity error, in most case for static base
%         lti - latitude
%         ts  - velocity sampling interval
% Output: phi - misalignment between calculating navigation frame and real
%               navigation frame
%
% See also  aa2phi.

% Copyright(c) 2009-2016, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 03/07/2016
global glv
    if nargin<3, ts = diff(vn(1:2,end)); end
    phi = vn;
    ki = timebar(1, length(vn)-fix(10/ts), 'vn2phi processing.');
    for k=fix(10/ts):length(vn)
        kts = (1:k)'*ts;
        A = [ones(length(kts),1), kts, kts.^2, kts.^3];
        aEN = invbc(A'*A)*A'*vn(1:k,1:2);
        [phit, phi0] = prls([aEN(2:4,1);aEN(2:4,2)], lti, kts(end));
        phi(k,1:3) = phit';
        ki = timebar;
    end
    phi(1:30,1:3) = repmat(phi0', 30, 1);
    figure, 
    subplot(211), plot(phi(:,4), phi(:,1:2)/glv.sec); xygo('phiEN');
    subplot(212), plot(phi(:,4), phi(:,3)/glv.min); xygo('phiU');

function [phit, phi0] = prls(aEN, lti, t)
global glv
    sl = sin(lti); cl = cos(lti); tl = sl/cl;
    wN = glv.wie*cl; wU = glv.wie*sl;
    a1E = aEN(1); a2E = aEN(2); a3E = aEN(3); a1N = aEN(4); a2N = aEN(5); a3N = aEN(6);
    
    uE = a2N/glv.g0; uN = -a2E/glv.g0; uU = uN*tl-a3N/(glv.g0*wN);
    phiE0 = a1N/glv.g0; phiN0 = -a1E/glv.g0; phiU0 = phiN0*tl-uE/wN;
    
    phiE = phiE0 + t*uE + t^2/2*(wU*uN-wN*uU);
    phiN = phiN0 + t*uN - t^2/2*wU*uE;
    phiU = phiU0 + t*uU + t^2/2*wU*uE;
    
    phi0 = [phiE0; phiN0; phiU0]; phit = [phiE; phiN; phiU];