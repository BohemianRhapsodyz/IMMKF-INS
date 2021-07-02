function kf = kfupdate(kf, yk, TimeMeasBoth)
% Discrete-time Kalman filter. 
%
% Prototype: kf = kfupdate(kf, yk, TimeMeasBoth)
% Inputs: kf - Kalman filter structure array
%         yk - measurement vector
%         TimeMeasBoth - described as follows,
%            TimeMeasBoth='T' (or nargin==1) for time updating only, 
%            TimeMeasBoth='M' for measurement updating only, 
%            TimeMeasBoth='B' (or nargin==2) for both time and 
%                             measurement updating.
% Output: kf - Kalman filter structure array after time/meas updating
% Notes: (1) the Kalman filter stochastic models is
%      xk = Phikk_1*xk_1 + wk_1
%      yk = Hk*xk + vk
%    where E[wk]=0, E[vk]=0, E[wk*wk']=Qk, E[vk*vk']=Rk, E[wk*vk']=0
%    (2) If kf.adaptive=1, then use Sage-Husa adaptive method (but only for 
%    measurement noise 'Rk'). The 'Rk' adaptive formula is:
%      Rk = b*Rk_1 + (1-b)*(rk*rk'-Hk*Pxkk_1*Hk')
%    where  minimum constrain 'Rmin' and maximum constrain 'Rmax' are
%    considered to avoid divergence.
%    (3) If kf.fading>1, the use fading memory filtering method.
%    (4) Using Pmax&Pmin to constrain Pxk, such that Pmin<=diag(Pxk)<=Pmax.
%
% See also  kfinit, kfupdatesq, kffk, kfhk, kfc2d, kffeedback, kfplot, RLS, ekf, ukf.

% Copyright(c) 2009-2015, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 08/12/2012, 29/08/2013, 16/04/2015, 01/06/2017, 11/03/2018
    if nargin==1;
        TimeMeasBoth = 'T';
    elseif nargin==2
        TimeMeasBoth = 'B';
    end
    
    if TimeMeasBoth=='T'            % Time Updating
        kf.xk = kf.Phikk_1*kf.xk;    
        kf.Pxk = kf.Phikk_1*kf.Pxk*kf.Phikk_1' + kf.Gammak*kf.Qk*kf.Gammak';
    else
        if TimeMeasBoth=='M'        % Meas Updating
            kf.xkk_1 = kf.xk;    
            kf.Pxkk_1 = kf.Pxk; 
        elseif TimeMeasBoth=='B'    % Time & Meas Updating
            kf.xkk_1 = kf.Phikk_1*kf.xk;    
            kf.Pxkk_1 = kf.Phikk_1*kf.Pxk*kf.Phikk_1' + kf.Gammak*kf.Qk*kf.Gammak';
        else
            error('TimeMeasBoth input error!');
        end
        kf.Pxykk_1 = kf.Pxkk_1*kf.Hk';
        kf.Py0 = kf.Hk*kf.Pxykk_1;
        kf.ykk_1 = kf.Hk*kf.xkk_1;
        kf.rk = yk-kf.ykk_1;
        if kf.adaptive==1  % for adaptive KF, make sure Rk is diag 24/04/2015
            for k=1:kf.m
                ry = kf.rk(k)^2-kf.Py0(k,k);
                if ry<kf.Rmin(k,k), ry = kf.Rmin(k,k); end
                if ry>kf.Rmax(k,k),     kf.Rk(k,k) = kf.Rmax(k,k);
                else                	kf.Rk(k,k) = (1-kf.beta)*kf.Rk(k,k) + kf.beta*ry;
                end
            end
            kf.beta = kf.beta/(kf.beta+kf.b);
        end
        kf.Pykk_1 = kf.Py0 + kf.Rk;
        kf.Kk = kf.Pxykk_1*invbc(kf.Pykk_1); % kf.Kk = kf.Pxykk_1*kf.Pykk_1^-1;
        kf.xk = kf.xkk_1 + kf.Kk*kf.rk;
        kf.Pxk = kf.Pxkk_1 - kf.Kk*kf.Pykk_1*kf.Kk';
        kf.Pxk = (kf.Pxk+kf.Pxk')*(kf.fading/2); % symmetrization & forgetting factor 'fading'
%         if kf.adaptive==1
%             krrk = kf.Kk*kf.rk*kf.rk'*kf.Kk';
%             for k=3:3
%                 krrki = krrk(k,k) + kf.Pxk(k,k) - kf.Pxkk_1(k,k);
%                 if krrki>kf.Qmax(k,k),     kf.Qk(k,k) = kf.Qmax(k,k);
%                 elseif krrki<kf.Qmin(k,k), kf.Qk(k,k) = (1-kf.beta)*kf.Qk(k,k) + kf.beta*kf.Qmin(k,k);
%                 else                	kf.Qk(k,k) = (1-kf.beta)*kf.Qk(k,k) + kf.beta*krrki;
%                 end
%             end
%         end
        if kf.xconstrain==1  % 16/3/2018
            for k=1:kf.n
                if kf.xk(k)<kf.xmin(k)
                    kf.xk(k)=kf.xmin(k);
                elseif kf.xk(k)>kf.xmax(k)
                    kf.xk(k)=kf.xmax(k);
                end
            end
        end
        if kf.pconstrain==1  % 1/6/2017
            for k=1:kf.n
                if kf.Pxk(k,k)<kf.Pmin(k)
                    kf.Pxk(k,k)=kf.Pmin(k);
                elseif kf.Pxk(k,k)>kf.Pmax(k)
                    ratio = sqrt(kf.Pmax(k)/kf.Pxk(k,k));
                    kf.Pxk(:,k) = kf.Pxk(:,k)*ratio;  kf.Pxk(k,:) = kf.Pxk(k,:)*ratio;
                end
            end
        end
    end
