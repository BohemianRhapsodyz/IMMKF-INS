function att1 = aaddmu(att0, mu)
% Calculate the new attitude 'att1' from old attitude 'att0' and
% installation error angles(expressed in body-frame). This function 
% is suitable for batch processing.
%
% Prototype: att1 = aaddmu(att0, mu)
% Inputs: att0 - reference Euler angles att0=[pitch0;roll0;yaw0]
%         mu - installation error angles mu=[mux;muy;muz]
% Output: att1 - Euler angles att1=[pitch1;roll1;yaw1]
%
% See also  aa2mu, aa2phi, m2rv, q2rv, m2att.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 03/11/2013
    [m, n] = size(att0);
    if n==1  % no batch processing
        att1 = m2att(mupdt(a2mat(att0),mu));
        return;
    end
    Cb0b = rv2m(mu);
    att1 = att0;
    s0 = sin(att0); c0 = cos(att0);
    for k=1:m
        si = s0(k,1); sj = s0(k,2); sk = s0(k,3); 
        ci = c0(k,1); cj = c0(k,2); ck = c0(k,3);
        Cnb0 = [ cj*ck-si*sj*sk, -ci*sk,  sj*ck+si*cj*sk;
                 cj*sk+si*sj*ck, ci*ck,   sj*sk-si*cj*ck;
                -ci*sj,          si,      ci*cj ];
        Cnb = Cnb0*Cb0b;
        att1(k,:) = [ asin(Cnb(3,2)),...
                      atan2(-Cnb(3,1),Cnb(3,3)),...
                      atan2(-Cnb(1,2),Cnb(2,2)) ];
    end
