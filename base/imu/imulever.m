function imu = imulever(imu, lv, Ts)
% 内杆臂补偿，认为三加计敏感轴相交于一点，Ts=1则认为输入是角速率而不是角增量
%
% See also  imurfu, imurot.

% Copyright(c) 2009-2015, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 31/03/2015
    if nargin<3, Ts = 1;  end
    lvTs = lv/Ts;
%     for k=1:size(imu,1)  % ACC = ACC - Wx(WxL)
%         w2 = imu(k,1:3).^2;
%         imu(k,4:6) = imu(k,4:6) + [w2(2)+w2(3), w2(3)+w2(1), w2(1)+w2(2)].*lvTs;
%     end
	w2 = imu(:,1:3).^2;
	imu(:,4:6) = imu(:,4:6) + [(w2(:,2)+w2(:,3))*lvTs(1), (w2(:,3)+w2(:,1))*lvTs(2), (w2(:,1)+w2(:,2))*lvTs(3)];
