function [qnb, att, Cnb, c] = mv2atti(vns, vbs, weight)
% Using multi-measurement vectors to determine attitude.
%
% Prototype: [qnb, att, Cnb] = dv2atti(vns, vbs)
% Inputs: vns - multi reference vectors in nav-frame
%         vbs - multi measurement vectors in body-frame
%         weight - weight(i) for vectors vns(i,:) & vbs(i,:)
% Outputs: qnb, att, Cnb - the same attitude representations in 
%               quaternion, Euler angles & DCM form
%
% See also  sv2atti, dv2atti, alignsb.

% Copyright(c) 2009-2016, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 26/07/2016
    len = size(vns,1);
    if nargin<3, weight = ones(len,1); end
    A = zeros(3);
    for k=1:size(vns,1)
        A = A + weight(k)*vns(k,:)'*vbs(k,:);
    end
    [u, s, v] = svd3(A);  s = diag(s);
	cmax = 1000; Cnb = eye(3);
    if det(A)>1e-6 
        c = max(s)/min(s);
        if c>cmax   % cond too large, reject
            c=cmax;
        else
            Cnb = u*v';
        end
    else  % negative det(A), fail
        c = -cmax;
    end
	[qnb, att] = attsyn(Cnb);
