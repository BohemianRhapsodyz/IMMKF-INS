function qnb = m2qua(Cnb)
% Convert direction cosine matrix(DCM) to attitude quaternion.
%
% Prototype: qnb = m2qua(Cnb)
% Input: Cnb - DCM from body-frame to navigation-frame
% Output: qnb - attitude quaternion
%
% See also  a2mat, a2qua, m2att, q2att, q2mat, attsyn, m2rv.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 21/02/2008, 15/03/2014, 04/02/2017
    C11 = Cnb(1,1); C12 = Cnb(1,2); C13 = Cnb(1,3); 
    C21 = Cnb(2,1); C22 = Cnb(2,2); C23 = Cnb(2,3); 
    C31 = Cnb(3,1); C32 = Cnb(3,2); C33 = Cnb(3,3); 
    if C11>=C22+C33
        q1 = 0.5*sqrt(1+C11-C22-C33);  qq4 = 4*q1;
        q0 = (C32-C23)/qq4; q2 = (C12+C21)/qq4; q3 = (C13+C31)/qq4;
    elseif C22>=C11+C33
        q2 = 0.5*sqrt(1-C11+C22-C33);  qq4 = 4*q2;
        q0 = (C13-C31)/qq4; q1 = (C12+C21)/qq4; q3 = (C23+C32)/qq4;
    elseif C33>=C11+C22
        q3 = 0.5*sqrt(1-C11-C22+C33);  qq4 = 4*q3;
        q0 = (C21-C12)/qq4; q1 = (C13+C31)/qq4; q2 = (C23+C32)/qq4;
    else
        q0 = 0.5*sqrt(1+C11+C22+C33);  qq4 = 4*q0;
        q1 = (C32-C23)/qq4; q2 = (C13-C31)/qq4; q3 = (C21-C12)/qq4;
    end
    qnb = [q0; q1; q2; q3];
    
%     qnb = [ 1.0 + Cnb(1,1) + Cnb(2,2) + Cnb(3,3);   % if Cnb~=I33, low accuracy !
%             1.0 + Cnb(1,1) - Cnb(2,2) - Cnb(3,3);
%             1.0 - Cnb(1,1) + Cnb(2,2) - Cnb(3,3);
%             1.0 - Cnb(1,1) - Cnb(2,2) + Cnb(3,3) ]; 
%     s = sign([ 1;
%                Cnb(3,2)-Cnb(2,3); 
%                Cnb(1,3)-Cnb(3,1); 
%                Cnb(2,1)-Cnb(1,2) ]);
%     qnb = s.*sqrt(abs(qnb))/2;   % sqrt(.) may decrease accuracy
