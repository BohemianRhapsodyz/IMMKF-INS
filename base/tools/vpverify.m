function vpverify(vp, posref)
% Verify the consistency for SINS velocity and position.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 01/12/2014
    ts = diff(vp(1:2,end));
    pos = vp(:,4:6);
    [RMh, clRNh] = RMRN(pos);
    dp = [vp(:,2)./RMh, vp(:,1)./clRNh, vp(:,3)]; % [VN,VE,VU] -> [dlat,dlon,dh]
    dp = cumtrapz(dp,1)*ts;
    figure,
    if nargin<2
        dpos = [pos(:,1)-pos(1,1), pos(:,2)-pos(1,2), pos(:,3)-pos(1,3)];
        plot(vp(:,end), [(dp(:,1)-dpos(:,1))*RMh(1),(dp(:,2)-dpos(:,2))*clRNh(1),dp(:,3)-dpos(:,3)]);
        xygo('poserr / m');
    else
        dpos = [pos(:,1)-pos(1,1), pos(:,2)-pos(1,2), pos(:,3)-pos(1,3)];
        dposref = [posref(:,1)-posref(1,1), posref(:,2)-posref(1,2), posref(:,3)-posref(1,3)];
        subplot(211)
        plot(vp(:,end), [(dp(:,1)-dpos(:,1))*RMh(1),(dp(:,2)-dpos(:,2))*clRNh(1),dp(:,3)-dpos(:,3)]);
        xygo('poserr / m');
        subplot(212)
        plot(vp(:,end), [(dp(:,1)-dposref(:,1))*RMh(1),(dp(:,2)-dposref(:,2))*clRNh(1),dp(:,3)-dposref(:,3)]);
        xygo('poserr / m');
    end

