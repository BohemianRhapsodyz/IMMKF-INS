function t = cnt2t(cnt, ts, t0)
% Convert wrapped uint8 count [0,255] or uint16 count [0,65535] to 
% continuous time tag.
%
% Prototype: t = cnt2t(cnt, ts)
% Inputs: cnt - wrapped integer count [0,255] or [0,65535
%         ts - sampling interval
%         t0 - start time
% Output: t - continuous time tag
%
% See also  dhms2t.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 29/03/2018
    if ~exist('ts', 'var'), ts = 1; end
    if ~exist('t0', 'var'), t0 = 1; end
    dcnt = diff(cnt);
    m = max(cnt);
    if m==15
        dcnt(dcnt==-15) = 1;
    elseif m==255
        dcnt(dcnt==-255) = 1;
    elseif m==65535
        dcnt(dcnt==-65535) = 1;
    else
        idx = dcnt<0;
        dcnt(idx) = dcnt(idx)+m;
    end
    t = cumsum([cnt(1);dcnt])*ts;
    if t0==0
        t = t - t(1) + ts;
    end