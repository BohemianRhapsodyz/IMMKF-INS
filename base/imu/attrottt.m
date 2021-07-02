function att = attrottt(att0, rotparas, ts)
% Attitude data simulation rotated by turntable.
%
% Prototype: att = attrottt(att0, rotparas, ts)
% Inputs: att0 - init attitude
%         rotparas -  tuntable rotation parameter arrays recorded as:
%                     [k, Ux, Uy, Uz, angles, T, T0, T1]
%         ts - IMU sampling interval
% Output: att - attitude output
%
% Example:
%   paras = [ [1, 0,0,1, 90*glv.deg, 10, 10, 10]; 
%             [2, 1,0,0, 45*glv.deg, 10, 10, 10];
%             [3, 0,1,0, 45*glv.deg, 10, 10, 10];
%             [4, 0,0,1, 45*glv.deg, 10, 10, 10] ];
%   att = attrottt(zeros(3,1), paras, 0.01);
%
% See also  imustatic.

% Copyright(c) 2009-2019, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 18/04/2019
    if size(rotparas,2)==6, rotparas(:,7)=10; end
    if size(rotparas,2)==7, rotparas(:,8)=rotparas(:,7); end
    [b, a] = ar1coefs(ts, 10*ts);
    att = att0';
    for k=1:size(rotparas,1)
        rpi = rotparas(k,:);
        U = rpi(2:4)'; U=U/sqrt(U'*U); angle = rpi(5); T = rpi(6); T0 = rpi(7); T1 = rpi(8);
        wi = angle/fix(T/ts);
        angles = [zeros(fix(T0/ts),1); (1:fix(T/ts))'*wi; zeros(fix(T1/ts),1)+angle];
        len = length(angles);
        angles = filtfilt(b,a, angles);
        atti = zeros(len, 3);
        Cnb0 = a2mat(att(end,:)');
        for kk=1:len
            atti(kk,:) = m2att(Cnb0*rv2m(U*angles(kk,:)'))';
        end
        att = [att; atti];
        Stage=rpi(1),
    end
    att(:,4) = (1:size(att,1))'*ts;
    insplot(att,'a');
