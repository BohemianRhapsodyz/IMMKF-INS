% Sagnac effect demostration
% See also  demo_scull_motion, demo_cone_motion.
% Copyright(c) 2009-2015, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 01/10/2015
function demo_sagnac_effect
    hfig = figure;
    for k=0:11
        if ~ishandle(hfig),  break;  end
        hold off;
        drawOneStep(k, -1);  % 0 for static, 1 for CW, -1 for CCW
        pause(0.5);
    end

function drawOneStep(k, cw)
    angle = cw*k*pi/180;
    afa = (0:pi/20:2*pi)';
    cir1 = 0.95*[sin(afa), cos(afa)];  cir2 = 1.05*[sin(afa), cos(afa)];
    scr = [-0.7, 1.2]; mirror = [0 0.8; 0 1.2]; boad = [0.6 1.7; 0.95 1.1];
    C = [cos(angle), -sin(angle); sin(angle), cos(angle)];
    cir1 = cir1*C; cir2 = cir2*C; scr = scr*C; mirror = mirror*C; boad = boad*C;
    plot(cir1(:,1),cir1(:,2), 'b-.', cir2(:,1),cir2(:,2), 'b-.'); hold on, 
    plot(0,0,'o', 'linewidth',2);
    plot(scr(1), scr(2), 'rx', 'linewidth', 3);
    plot(mirror(:,1), mirror(:,2), 'linewidth',3);
    plot(boad(:,1), boad(:,2), 'k', mean(boad(:,1)), mean(boad(:,2)), 'xk', 'linewidth',2);
    xlim([-2.5,2.5]); axis equal;
    if k==0
        plot([scr(1), mean(mirror(:,1))], [scr(2), mean(mirror(:,2))], 'r:', 'linewidth',2)
        pause(1);
    elseif k==11
        angle = (-118+cw*k)*pi/180; C = [cos(angle), -sin(angle); sin(angle), cos(angle)];
        x = (-10:0.21:10)'; yy = [0.02*x, 0.4*abs(sin(x)./x)]*C;
        r1 = 0.5-0.1*cw; r2 = 0.5+0.1*cw;
        mx = r1*boad(1,1)+r2*boad(2,1); my = r1*boad(1,2)+r2*boad(2,2); 
        plot(yy(:,1)+mx,yy(:,2)+my, 'r', 'linewidth',2)
        plot([mean(mirror(:,1)), mx], [mean(mirror(:,2)), my], 'r:', 'linewidth',2)
    else
        afa = (((k-1)*36+5)*pi/180:pi/20:(k*36-5)*pi/180)';
        cir1 = [sin(afa), cos(afa)]; cir2 = [sin(2*pi-afa), cos(2*pi-afa)];
        plot(cir1(:,1),cir1(:,2), 'r:', cir2(:,1),cir2(:,2), 'm:', 'linewidth',3);
    end

