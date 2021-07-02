% Several attitude updating methods are compared.
% See also  qrk4, btzrk4, qpicard, qtaylor, dcmtaylor, cnscl.
% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 14/02/2017
glvs
[nn, ts, nts] = nnts(4, 0.01);  % subsamples & sampling interval
afa = 90.0*glv.deg;              % half-apex angle
f = 2;  w = 2*pi*f;             % frequency
T = 1;                          % simulation time
[wm, qr] = conesimu(afa, f, ts, T);
% [wm, qr] = highmansimu(randn(3,5), ts, T, 1);
coef = wm2wtcoef(ts, nn);
len = length(wm); res = zeros(fix(len/nn), 18);
q1 = qr(1,:)'; q2 = q1; q3 = q1; q4 = q1; q5 = q1; q6 = q1; ki = 1;
for k=1:nn:len-nn+1
    k1 = k+nn-1;
	wmi = wm(k:k1, :);	q0 = qr(k1+1,:)';
	phim = cnscl(wmi, 1);  q1 = qmul(q1,rv2q(phim)); % optimal method
    phim = cnscl(wmi, 2);  q2 = qmul(q2,rv2q(phim)); % uncompressed method
    q3 = qrk4(q3, wmi, nts);  % quaternion Runge-Kutta  % q2 = qrk4bad(q2, wm(k:k1+1, :), nts); X
    q4 = qmul(q4, rv2q(btzrk4(wmi, nts)));  % Bortz Runge-Kutta
    q5 = qmul(q5, qpicard(wmi'*coef, nts));
%     q6 = qmul(q6, qtaylor(wmi'*coef, nts));
    q6 = qmul(q6, m2qua(dcmtaylor(wmi'*coef, nts)));
	res(ki,:) = [qq2phi(q1,q0); qq2phi(q2,q0); qq2phi(q3,q0); qq2phi(q4,q0); qq2phi(q5,q0); qq2phi(q6,q0)]';  ki = ki+1;
%     if k==nn*5
%         q1=q0; q2=q0; ...
%     end
end
figure
t = (1:size(res,1))*nts;
subplot(131), plot(t, res(:,1:6)/glv.sec), xygo('\phi / \prime\prime');
subplot(132), plot(t, res(:,7:12)/glv.sec), xygo('\phi / \prime\prime');
subplot(133), plot(t, res(:,13:18)/glv.sec), xygo('\phi / \prime\prime');