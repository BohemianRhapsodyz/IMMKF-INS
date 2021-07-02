function kfplot(xkpk, varargin)
% Plot Kalman filter results, including state and variance.
%
% Prototype: kfplot(xkpk, varargin)
% Inputs: xkpk - Kalman filter state vector estimation and variance
%         varargin - if any other parameters (such as true values)
%
% See also  insplot, inserrplot, POSplot, kfupdate, kftypedef, psinstypedef.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 05/10/2013
global psinsdef
    switch psinsdef.kfplot
        case {15,18,19} % psinsdef.kfplotxx
            inserrplot(xkpk(:,[1:psinsdef.kfplot,end]));
            if nargin>1
                if psinsdef.kfplot==15
                    trueplot15(varargin);
                elseif psinsdef.kfplot==18
                    trueplot18(varargin);
                elseif psinsdef.kfplot==19
                    trueplot19(varargin);
                elseif psinsdef.kfplot==34
                end
            end
            inserrplot([sqrt(xkpk(:,psinsdef.kfplot+1:end-1)),xkpk(:,end)]);
        case 34
            inserrplot(xkpk(:,[1:19,end]));
            if nargin>1, trueplot19(varargin); end
            inserrplot(xkpk(:,[20:34,end]),'kgka');
            if nargin>1, trueplotkga(varargin); end
            inserrplot([sqrt(xkpk(:,35:68)),xkpk(:,end)]);
        case 37
            inserrplot(xkpk(:,[1:19,end]));
            if nargin>1, trueplot19(varargin); end
            inserrplot(xkpk(:,[20:37,end]),'kgkadv');
            if nargin>1, trueplotkgadv(varargin); end
            inserrplot([sqrt(xkpk(:,38:74)),xkpk(:,end)]);
        otherwise,
            feval(psinsdef.typestr, psinsdef.kfplottag, [{xkpk},varargin]);            
    end

function trueplot15(varargin)
global glv
    [avperr, imuerr] = setvals(varargin);
    t = avperr(:,end); len = length(t);
    subplot(321), hold on, plot(t, avperr(:,1:2)/glv.sec, 'm--');
    subplot(322), hold on, plot(t, avperr(:,3)/glv.min, 'm--');
    subplot(323), hold on, plot(t, avperr(:,4:6), 'm--');
    subplot(324), hold on, plot(t, [avperr(:,7:8)*glv.Re,avperr(:,9)], 'm--');
    subplot(325), hold on, plot(t, repmat(imuerr.eb'/glv.dph,len,1), 'm--');
    subplot(326), hold on, plot(t, repmat(imuerr.db'/glv.ug,len,1), 'm--');

function trueplot18(varargin)
global glv
    [avperr, imuerr, lever] = setvals(varargin);
    t = avperr(:,end); len = length(t);
    subplot(421), hold on, plot(t, avperr(:,1:2)/glv.sec, 'm--');
    subplot(422), hold on, plot(t, avperr(:,3)/glv.min, 'm--');
    subplot(423), hold on, plot(t, avperr(:,4:6), 'm--');
    subplot(424), hold on, plot(t, [avperr(:,7:8)*glv.Re,avperr(:,9)], 'm--');
    subplot(425), hold on, plot(t, repmat(imuerr.eb'/glv.dph,len,1), 'm--');
    subplot(426), hold on, plot(t, repmat(imuerr.db'/glv.ug,len,1), 'm--');
    subplot(427), hold on, plot(t, repmat(lever',len,1), 'm--');

function trueplot19(varargin)
global glv
    [avperr, imuerr, lever, dT] = setvals(varargin);
    t = avperr(:,end); len = length(t);
    subplot(421), hold on, plot(t, avperr(:,1:2)/glv.sec, 'm--');
    subplot(422), hold on, plot(t, avperr(:,3)/glv.min, 'm--');
    subplot(423), hold on, plot(t, avperr(:,4:6), 'm--');
    subplot(424), hold on, plot(t, [avperr(:,7:8)*glv.Re,avperr(:,9)], 'm--');
    subplot(425), hold on, plot(t, repmat(imuerr.eb'/glv.dph,len,1), 'm--');
    subplot(426), hold on, plot(t, repmat(imuerr.db'/glv.ug,len,1), 'm--');
    subplot(427), hold on, plot(t, repmat(lever',len,1), 'm--');
    subplot(428), hold on, plot(t, repmat(dT,len,1), 'm--');
    
function trueplotkga(varargin)
global glv
    [avperr, imuerr] = setvals(varargin);
    t = avperr(:,end); len = length(t);
    subplot(221), hold on, plot(t, repmat(imuerr.dKga([1,5,9])'/glv.ppm,len,1), 'm--');
    subplot(322), hold on, plot(t, repmat(imuerr.dKga([2,3,6])'/glv.sec,len,1), 'm--');
    subplot(324), hold on, plot(t, repmat(imuerr.dKga([4,7,8])'/glv.sec,len,1), 'm--');
    subplot(223), hold on, plot(t, repmat(imuerr.dKga([10,13,15])'/glv.ppm,len,1), 'm--');
    subplot(326), hold on, plot(t, repmat(imuerr.dKga([11,12,14])'/glv.sec,len,1), 'm--');

function trueplotkgadv(varargin)
global glv
    [avperr, imuerr] = setvals(varargin);
    t = avperr(:,end); len = length(t);
    subplot(321), hold on, plot(t, repmat(imuerr.dKga([1,5,9])'/glv.ppm,len,1), 'm--');
    subplot(322), hold on, plot(t, repmat(imuerr.dKga([2,3,6])'/glv.sec,len,1), 'm--');
    subplot(324), hold on, plot(t, repmat(imuerr.dKga([4,7,8])'/glv.sec,len,1), 'm--');
    subplot(323), hold on, plot(t, repmat(imuerr.dKga([10,13,15])'/glv.ppm,len,1), 'm--');
    subplot(326), hold on, plot(t, repmat(imuerr.dKga([11,12,14])'/glv.sec,len,1), 'm--');
