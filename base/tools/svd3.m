function [u, s, v] = svd3(A)
% Singular value decomposition for 3-order matrix. This routine is convenient 
% for C-language programmer.
%
% Prototype: [u, s, v] = svd3(A)
% Input:   A     - 3-order matrix
% Outputs: u,s,v - u and v are unitary matrices, s is a diagonal matrix,
%                  so that A = u*s*v'.
%
% See also  N/A.

% Copyright(c) 2009-2016, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 01/02/2016
    B = A'*A;
    a = -(B(1,1)+B(2,2)+B(3,3));
    b = B(1,1)*B(2,2)+B(1,1)*B(3,3)+B(2,2)*B(3,3)-B(2,3)^2-B(1,2)^2-B(1,3)^2;
    c = -(B(1,1)*B(2,2)*B(3,3)-B(1,1)*B(2,3)^2-B(1,2)^2*B(3,3)+2*B(1,2)*B(1,3)*B(2,3)-B(1,3)^2*B(2,2));
    [rs, state] = roots3([1;a;b;c]);
    rs = sort(abs(rs), 'descend');
    if state==1
        v1 = [1;0;0]; v2 = [0;1;0]; v3 = [0;0;1];
    elseif state==2
        C = rs(2)*eye(3)-B;
        m = 0;
        for i=1:3
            for j=1:3
                Cij = abs(C(i,j));
                if m<Cij, I=i; J=j; m=Cij; end
            end
        end
        ci = C(I,:)';
        if J<3, v2 = [ci(2); -ci(1); 0]; 
        else v2 = [0; -ci(3); ci(2)]; end
        if rs(1)==rs(2)
            v1 = cross(ci,v2); v3 = cross(v1,v2);
        else
            v3 = cross(ci,v2); v1 = cross(v3,v2);
        end
    elseif state==3
        C = rs(1)*eye(3)-B;
        vt1 = cross(C(1,:),C(2,:));
        vt2 = cross(C(2,:),C(3,:));
        vt3 = cross(C(3,:),C(1,:));
        nvt1 = vt1*vt1';
        nvt2 = vt2*vt2';
        nvt3 = vt3*vt3';
        if     nvt1>nvt2&&nvt1>nvt3, v1 = vt1';
        elseif nvt2>nvt1&&nvt2>nvt3, v1 = vt2';
        else                         v1 = vt3'; end
        C = rs(2)*eye(3)-B;
        vt1 = cross(C(1,:),C(2,:));
        vt2 = cross(C(2,:),C(3,:));
        vt3 = cross(C(3,:),C(1,:));
        nvt1 = vt1*vt1';
        nvt2 = vt2*vt2';
        nvt3 = vt3*vt3';
        if     nvt1>nvt2&&nvt1>nvt3, v2 = vt1';
        elseif nvt2>nvt1&&nvt2>nvt3, v2 = vt2';
        else                         v2 = vt3'; end
        v3 = cross(v1,v2);
    else
        v1 = [1;0;0]; v2 = [0;1;0]; v3 = [0;0;1];
%         error('Complex roots in svd3 is impossible.');
    end
    v = [v1/norm(v1), v2/norm(v2), v3/norm(v3)];
    s = diag(sqrt(rs));
    u = A*v*s^-1;
        
        

