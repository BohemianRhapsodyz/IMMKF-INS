function [coef, kij] = conepolycoef(nn, pp)
% The generation of coning error compensation coefficients using Taylor
% serials method.
%
% Prototype: [coef, kij] = conepolycoef(nn, pp)
% Inputs: nn - sub-sample number in current attitude updating interval
%         pp - previous sub-samples used
% Outputs: coef - coning compensation coefficients
%          kij - the subscript denotation of sub-sample coefficients
%
% See also  conecoef, conedrift, cnscl, conesimu, insupdate.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 20/02/2017
    if nargin<2,  pp = 0;  end
    NN = nn + pp;
    coef = wm2wtcoef(1/nn, nn, NN);
    ij = nchoosek(1:NN,2);           der = repmat(NN:-1:1,3,1);
    A = zeros(3*NN,NN*(NN-1)/2);     E = zeros(3*NN,1);
    for k=1:NN
        wmi = randn(3,NN);
        Wt = wmi*coef;  At = Wt./der;
        dphi = polycross(1/2*At, Wt);  sz2 = size(dphi,2);
%         der1 = repmat(size([dphi,[0;0;0]],2):-1:1,3,1);
%         U = [[dphi,[0;0;0]]./der1,[0;0;0]];
%         E(3*k-2:3*k,1) = sum(U,2);
        for kk=sz2-1:-1:2
            E(3*k-2:3*k,1) = E(3*k-2:3*k,1) + dphi(:,kk)/(sz2-kk+2);
        end
        for kk=1:size(ij,1)
            A(3*k-2:3*k,kk) = cross(wmi(:,ij(kk,1)), wmi(:,ij(kk,2)));
        end
    end
    coef = (A'*A)^-1*A'*E;
    kij = ij-(NN-nn);
%     disp([X, kij]);
%     for k=1:size(ij,1),  a(ij(k,1),ij(k,2))=coef(k);  end
%     disp(a);
