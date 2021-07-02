function seg = trjsegment(seg, segtype, lasting, w, a, var1)
% Add trjsegment setting for trajectory simulator.
%
% Prototype: seg = trjsegment(seg, segtype, lasting, w, a, var1)
% Inputs: seg - trjsegment structure array
%         segtype - trjsegment type
%         lasting - segment lasting time
%         w - trajectory angular rate (NOTE: in deg/sec!)
%         a - trajectory acceleration
%         var1 - augmented input, see code in detail
% Output: seg - new trjsegment structure array
%          
% See also  trjsimu, insupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 07/01/2014
    dps = pi/180/1;  % deg/second
    if exist('w', 'var')
        cf = (w*dps)*seg.vel; % centripetal force
    end
    switch(segtype)
        case 'init' % trjsegment(***, 'init', initvelocity)
            initvelocity = lasting;
            seg = [];
            seg.vel = initvelocity;  seg.wat = [];
        % basic ------
        case 'uniform', % trjsegment(seg, 'uniform', lasting)
            seg.wat = [seg.wat; [lasting, seg.vel, 0, 0, 0, 0, 0, 0]];
        case 'accelerate',
            seg.wat = [seg.wat; [lasting, seg.vel, 0, 0, 0, 0, a, 0]];
            seg.vel = seg.vel + lasting*a;
        case 'deaccelerate',
            seg.wat = [seg.wat; [lasting, seg.vel, 0, 0, 0, 0,-a, 0]];
            seg.vel = seg.vel - lasting*a;
        case 'headup',
            seg.wat = [seg.wat; [lasting, seg.vel, w*dps, 0, 0, 0, 0, cf]];
        case 'headdown',
            seg.wat = [seg.wat; [lasting, seg.vel,-w*dps, 0, 0, 0, 0,-cf]];
        case 'turnleft',
            seg.wat = [seg.wat; [lasting, seg.vel, 0, 0, w*dps,-cf, 0, 0]];
        case 'turnright',
            seg.wat = [seg.wat; [lasting, seg.vel, 0, 0,-w*dps, cf, 0, 0]];
        case 'rollleft',
            seg.wat = [seg.wat; [lasting, seg.vel, 0,-w*dps, 0, 0, 0, 0]];
        case 'rollright',
            seg.wat = [seg.wat; [lasting, seg.vel, 0, w*dps, 0, 0, 0, 0]];
        % compound ------
        case 'coturnleft', % coordinate turn left
            rolllasting = var1; rollw = atan(cf/9.8)/dps/rolllasting;
            seg = trjsegment(seg, 'rollleft',  rolllasting, rollw);
            seg = trjsegment(seg, 'turnleft',  lasting, w);
            seg = trjsegment(seg, 'rollright', rolllasting, rollw);
        case 'coturnright', % coordinate turn right
            rolllasting = var1; rollw = atan(cf/9.8)/dps/rolllasting;
            seg = trjsegment(seg, 'rollright', rolllasting, rollw);
            seg = trjsegment(seg, 'turnright', lasting, w);
            seg = trjsegment(seg, 'rollleft',  rolllasting, rollw);
        case '8turn',
            lasting = 360/w;
            rolllasting = var1;
            seg = trjsegment(seg, 'coturnleft',  lasting, w, 0, rolllasting);
            seg = trjsegment(seg, 'coturnright', lasting, w, 0, rolllasting);
        case 'sturn',
            lasting1 = 90/w; lasting2 = 180/w;
            rolllasting = var1;
            seg = trjsegment(seg, 'coturnright', lasting1, w, 0, rolllasting);
            seg = trjsegment(seg, 'coturnleft',  lasting2, w, 0, rolllasting);
            seg = trjsegment(seg, 'coturnright', lasting1, w, 0, rolllasting);
            seg = trjsegment(seg, 'coturnleft',  lasting1, w, 0, rolllasting);
            seg = trjsegment(seg, 'coturnright', lasting2, w, 0, rolllasting);
            seg = trjsegment(seg, 'coturnleft',  lasting1, w, 0, rolllasting);
        case 'climb',
            uniformlasting = var1;
            seg = trjsegment(seg, 'headup',   lasting, w);
            seg = trjsegment(seg, 'uniform',  uniformlasting);
            seg = trjsegment(seg, 'headdown', lasting, w);
        case 'descent',
            uniformlasting = var1;
            seg = trjsegment(seg, 'headdown', lasting, w);
            seg = trjsegment(seg, 'uniform',  uniformlasting);
            seg = trjsegment(seg, 'headup',   lasting, w);
        otherwise,
            error('trjsegment type mismatch.');
    end

