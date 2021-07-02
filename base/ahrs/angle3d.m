function v = angle3d(v1, v2)
% Space angle vector from unit vector 'v1' to 'v2'.
%
% Prototype: v = angle3d(v1, v2)
% Inputs: v1, v2 - unit 3D vector
% Output: v - space angle vector

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 07/06/2017, 10/04/2019
%     phi = cros(v1, v2);
%     n = norm(phi);
%     if n==0
%         phi = v1; afa = 0;
%     else
%         phi = phi/n;
%         afa = acos(v1'*v2/norm(v1)/norm(v2));
%     end
%     v = afa*phi;
    
    vv = v1+v2;
    nm = norm(vv);
    if nm>1e-6
        v = cros(v1,v2);
        if nm<1.8
            ang = acos(v1'*v2);
            v = v/norm(v)*ang;
        end
    else  % v1 ~= -v2
        if v1(1)>0.5 || v1(2)>0.5
            v = [v1(2);-v1(1);0];
        else
            v = [0;v1(3);-v1(2)];
        end
        v = v/norm(v)*pi;
    end