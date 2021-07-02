function Vq = interplim(X, V, Xq)
% Linear interpolation with limitation Vq @ [V(1), V(2)].
%             V(2)-V(1)
% Vq = V(1) + ---------  *  (Xq-X(1))
%             X(2)-X(1)
%
% See also interp1.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 05/03/2017
    assert(X(1)<X(2));
    if     Xq<X(1),  Vq=V(1);  return; 
    elseif Xq>X(2),  Vq=V(2);  return;
    end
    kk = (V(2)-V(1))/(X(2)-X(1));
    Vq = V(1) + kk*(Xq-X(1));