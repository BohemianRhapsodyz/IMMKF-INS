function odplot(od)
% Odometer plot.
%
% Prototype: odplot(od)
% Inputs: od - [od_increment, t].
%          
% See also  imuplot, insplot, inserrplot, kfplot, gpsplot, gpssimu, avpfile.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 24/02/2018
    myfigure;
    ts = (od(end,end)-od(1,end))/length(od);
    if size(od,2)==4
        nv = normv(od(:,1:3));
        plot(od(:,end), od(:,1:3)/ts);
    else
        nv = od(:,1);
    end
    hold on, plot(od(:,end), nv/ts, 'm');
    xygo('OD Velocity / m/s');
    title(sprintf('Distance = %.4f (m)', sum(nv)));
    
