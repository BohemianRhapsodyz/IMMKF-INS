% Sculling motion simulation.
% See also  demo_scull_error, demo_cone_motion, demo_cone_error.
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 03/04/2012, 28/03/2014
clear all
glvs
Ae = 30.0*glv.deg;  Ap = 1;      % angular & linear amplitude
f = 1;  w = 2*pi*f;              % frequency
ts = 0.05;                       % sampling interval
[wvm, avp] = scullsimu(Ae, Ap, f, ts, 1/f);
len = length(avp); 
avp(:,8:9) = [avp(:,8)-min(avp(:,8))/2, avp(:,9)-min(avp(:,9))];
[xk, yk, zk] = setvals(zeros(len,3));
for k=1:len
    Cnb = a2mat(avp(k,1:3)'); Pt = avp(k,7:9)';
    xk(k,:) = Cnb*[1;0;0]+Pt;  yk(k,:) = Cnb*[0;1;0]+Pt;  zk(k,:) = Cnb*[0;0;1]+Pt;
end
hfig = myfigure; ki = 1;
while 1
    Pt = avp(ki,7:9)';
    x = xk(ki,:);  y = yk(ki,:);  z = zk(ki,:);
    if ~ishandle(hfig),  break;  end
    clf(hfig);
    subplot(121); hold off;
    plot3([0,1.5],[0,0],[0,0],'m', ...
          [0,0],[0,1.5],[0,0],'m', ...
          [0,0],[0,0],[0,1.5], 'm'); % coordinate frame
    axis([-1.5 1.5 -1.5 1.5 -1.5 1.5]); view([1 1.2 1.1]); hold on; grid on
    plot3([Pt(1),x(1)],[Pt(2),x(2)],[Pt(3),x(3)],'-o', ...
          [Pt(1),y(1)],[Pt(2),y(2)],[Pt(3),y(3)],'-o', ...
          [Pt(1),z(1)],[Pt(2),z(2)],[Pt(3),z(3)],'-o', 'LineWidth', 3); % body frame
    plot3(xk(:,1),xk(:,2),xk(:,3), ...
          yk(:,1),yk(:,2),yk(:,3), ...
          zk(:,1),zk(:,2),zk(:,3));   % tracks
    title('Sculling Motion Simulation (by Yan G M)'); 
    xlabel('X'); ylabel('Y'); zlabel('Z');
    subplot(122); hold off;
    plot((0:len-1)*ts,avp(:,7:9)); xygo('Original coordinates X,Y,Z');
    plot(ki*ts-ts,avp(ki,7:9),'o', 'LineWidth', 3);
    pause(.2); 
    if ki>=len, ki = 1;  else ki = ki+1;  end
end
