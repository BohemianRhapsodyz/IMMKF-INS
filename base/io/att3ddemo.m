function att3ddemo(att, fps)
% Display attitude motion in 3-D coordinate system.
%
% Prototype: att3ddemo(att, ts)
% Inputs: att - attitude array
%         fps - display frequency, i.e. frames per second
%
% See also  insplot.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 26/08/2014
    if nargin<2, fps=1/diff(att(1:2,4)); end
    if size(att,2)<4, att = [att,(1:length(att))'];  end
    t = (0:1/fps:att(end,4))';
    att = interp1(att(:,4), att(:,1:3), t); att = [att,t];
    len = length(att);
    [xk, yk, zk] = prealloc(len, 3);
    hfig = figure;
    for k=1:len
        qnb = a2qua(att(k,1:3)');
        x = qmulv(qnb,[1;0;0]);    y = qmulv(qnb,[0;1;0]);    z = qmulv(qnb,[0;0;1]);
        xk(k,:) = x'; yk(k,:) = y'; zk(k,:) = z';
        if ~ishandle(hfig),  break;  end
        clf(hfig);  hold off;
        plot3([0,1.5],[0,0],[0,0],'m', ...
            [0,0],[0,1.5],[0,0],'m', ...
            [0,0],[0,0],[0,1.5], 'm'); % coordinate frames
        axis([-1.5 1.5 -1.5 1.5 -1.5 1.5]); view([1 1.2 1.1]); hold on; grid on
        title('Attitude Motion Simulation (by Yan G M)'); 
        xlabel('X'); ylabel('Y'); zlabel('Z'); 
        plot3([0,x(1)],[0,x(2)],[0,x(3)],'-o', ...
            [0,y(1)],[0,y(2)],[0,y(3)],'-o', ...
            [0,z(1)],[0,z(2)],[0,z(3)],'-o','LineWidth',3); % body frame
        k1 = 1:k;
        plot3(xk(k1,1),xk(k1,2),xk(k1,3), ...
            yk(k1,1),yk(k1,2),yk(k1,3), ...
            zk(k1,1),zk(k1,2),zk(k1,3)); % tracks
        pause(1/fps);
    end