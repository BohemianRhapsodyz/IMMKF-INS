function mu = aa2mu(att1, att0)
% Calculate the installation error angles(expressed in body-frame) 
% between att1 and att0, i.e. calculate rotation vector between att1 
% and att0, This function is suitable for batch processing.
%
% Prototype: mu = aa2mu(att1, att0)
% Inputs: att1 - Euler angles att1=[pitch1;roll1;yaw1]
%         att0 - reference Euler angles att0=[pitch0;roll0;yaw0]
% Output: mu - installation error angles mu=[mux;muy;muz]
%
% See also  aa2phi, m2rv, q2rv.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 03/11/2013, 21/12/2017
    [m, n] = size(att1);
    if n==1  % no batch processing
        mu = -q2rv( qmul(qconj(a2qua(att1)),a2qua(att0)) );
        return;
    end
    mu = att1;
    s1 = sin(att1); c1 = cos(att1);
    s0 = sin(att0); c0 = cos(att0);
    for k=1:m
        si = s1(k,1); sj = s1(k,2); sk = s1(k,3); 
        ci = c1(k,1); cj = c1(k,2); ck = c1(k,3);
        Cnb1 = [ cj*ck-si*sj*sk, -ci*sk,  sj*ck+si*cj*sk;
                 cj*sk+si*sj*ck, ci*ck,   sj*sk-si*cj*ck;
                -ci*sj,          si,      ci*cj ];
        si = s0(k,1); sj = s0(k,2); sk = s0(k,3); 
        ci = c0(k,1); cj = c0(k,2); ck = c0(k,3);
        Cnb0 = [ cj*ck-si*sj*sk, -ci*sk,  sj*ck+si*cj*sk;
                 cj*sk+si*sj*ck, ci*ck,   sj*sk-si*cj*ck;
                -ci*sj,          si,      ci*cj ];
        Cbb = Cnb1'*Cnb0;
        mu(k,:) = [Cbb(2,3)-Cbb(3,2), Cbb(3,1)-Cbb(1,3), Cbb(1,2)-Cbb(2,1)]/2.0;
    end
