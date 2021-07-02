function avp = avpmdf(avp0, xk, ebth, dbth)
% AVP modification, always used by Kalman filter output modification.
%
% Prototype: avp = avpmdf(avp0, xk, ebth, dbth)
% Input: avp0 - SINS avp output
%        xk - Kalman filter state estimation
%        ebth - gyro drift threshold
%        dbth - acc bias threshold
% Output: avp - avp output after modification
% 
% See also  kffeedback, avpset, avpseterr.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 19/10/2014
    if nargin<3, ebth=0; end
    if nargin<4, dbth=0; end
    Cnb = a2mat(avp0(1:3));
    en = Cnb*xk(10:12); dn = Cnb*xk(13:15);
    if en(1)>ebth, en(1)=en(1)-ebth; 
    elseif en(1)<-ebth, en(1)=en(1)+ebth; end
    if dn(1)>dbth, dn(1)=dn(1)-dbth; 
    elseif dn(1)<-dbth, dn(1)=dn(1)+dbth; end
    if dn(2)>dbth, dn(2)=dn(2)-dbth; 
    elseif dn(2)<-dbth, dn(2)=dn(2)+dbth; end
    phi = xk(1:3) + [-dn(2)/9.8; dn(1)/9.8; en(1)/(7.29e-5*cos(avp0(7)))];
    avp(1:3) = [q2att(qdelphi(a2qua(avp0(1:3)),phi)); avp0(4:9)-xk(4:9)];

