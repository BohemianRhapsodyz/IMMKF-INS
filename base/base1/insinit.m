function ins = insinit(avp0, ts, var1, var2)
% SINS structure array initialization.
%
% Prototype: ins = insinit(avp0, ts, var1, var2)
% Initialization usages(maybe one of the following methods):
%       ins = insinit(avp0, ts);
%       ins = insinit(avp0, ts, avperr);
%       ins = insinit(qnb0, vn0, pos0, ts);
% Inputs: avp0 - initial avp0 = [att0; vn0; pos0]
%         ts - SIMU sampling interval
%         avperr - avp error setting
% Output: ins - SINS structure array
%
% See also  insupdate, avpset, kfinit.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 22/03/2008, 12/01/2013, 18/03/2014
global glv
    avp0 = avp0(:);
    if length(avp0)==1, avp0=zeros(9,1); end  % ins = insinit(0, ts);
    if nargin==2      % ins = insinit(avp0, ts);
        [qnb0, vn0, pos0] = setvals(a2qua(avp0(1:3)), avp0(4:6), avp0(7:9));
    elseif nargin==3  % ins = insinit(avp0, ts, avperr);
        avperr = var1;
        avp0 = avpadderr(avp0, avperr);
        [qnb0, vn0, pos0] = setvals(a2qua(avp0(1:3)), avp0(4:6), avp0(7:9));
	elseif nargin==4  % ins = insinit(qnb0, vn0, pos0, ts);
        [qnb0, vn0, pos0, ts] = setvals(avp0, ts, var1, var2);
    end        
	ins = [];
	ins.ts = ts; ins.nts = [];
    [ins.qnb, ins.vn, ins.pos] = setvals(qnb0, vn0, pos0); 
	[ins.qnb, ins.att, ins.Cnb] = attsyn(ins.qnb);  ins.Cnb0 = ins.Cnb;
    ins.avp  = [ins.att; ins.vn; ins.pos];
    ins.eth = ethinit(ins.pos, ins.vn);
	% 'wib,web,fn,an,Mpv,MpvCnb,Mpvvn,CW' may be very useful outside SINS,
    % so we calucate and save them.
    ins.wib = ins.Cnb'*ins.eth.wnin;
    ins.fn = -ins.eth.gn;  ins.fb = ins.Cnb'*ins.fn;
	[ins.wnb, ins.web, ins.an] = setvals(zeros(3,1));
	ins.Mpv = [0, 1/ins.eth.RMh, 0; 1/ins.eth.clRNh, 0, 0; 0, 0, 1];
    ins.MpvCnb = ins.Mpv*ins.Cnb;  ins.Mpvvn = ins.Mpv*ins.vn; 
	[ins.Kg, ins.Ka] = setvals(eye(3)); % calibration parameters
    [ins.eb, ins.db] = setvals(zeros(3,1));
    [ins.tauG, ins.tauA] = setvals(inf(3,1)); % gyro & acc correlation time
    ins.lever = zeros(3,1); ins = inslever(ins); % lever arm
	ins.tDelay = 0; % time delay
    glv.wm_1 = zeros(3,1)';  glv.vm_1 = zeros(3,1)';  % for 'single sample+previous sample' coning algorithm
    ins.an0 = zeros(3,1);
